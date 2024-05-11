//
//  CartView.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        VStack {
            if viewModel.cartItems.isEmpty {
                Text("Your cart is empty")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.cartItems) { cartItem in
                        CartItemRowView(cartItem: cartItem, viewModel: viewModel) // Pass view model to CartItemRowView
                    }
                    .onDelete(perform: deleteCartItem)
                }
            }
            
            Spacer()
            
            Text("Total: $\(viewModel.totalPrice)")
                .font(.headline)
                .padding()
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchCartItems()
        }
        .navigationTitle("Cart")
    }
    
    private func deleteCartItem(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteProductFromCart(at: index)
        }
    }
}




struct CartItemRowView: View {
    var cartItem: CartItem
    @State private var productImage: UIImage? = nil
    @State private var quantity: Int = 1 // Initialize with default quantity
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        
        if let product = cartItem.relationship {
            
            NavigationLink(destination: ProductDetailsView(viewModel: ProductViewModel(), cartViewModel: viewModel, product: product)) {
                // Your content here
                  
                    HStack {
                        if let imageName = cartItem.relationship?.image,
                           let uiImage = UIImage(named: imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .onAppear {
                                    // Load the image asynchronously
                                    productImage = uiImage
                                }
                        } else {
                            // Placeholder image if image name is invalid or not available
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            if let productName = cartItem.relationship?.name {
                                Text(productName)
                                    .font(.headline)
                            }
                            if let productPrice = cartItem.relationship?.price {
                                Text("$\(productPrice) x \(cartItem.quantity)") // Show updated quantity
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer() // Pushes the Stepper to the right corner
                        
                        // Stepper for updating quantity
                
                        Stepper("", value: $quantity, in: 1...Int.max)
                            .labelsHidden() // Hide the labels of the stepper
                            .onChange(of: quantity) { newQuantity in
                                

                                cartItem.quantity = Int32(newQuantity)
                                // Save the changes to Core Data
                                do {
                                    try? CoreDataStack.shared.saveContext()
                                    viewModel.updateTotalPrice()
                                } catch {
                                    print("Error saving quantity: \(error.localizedDescription)")
                                }
                            }
                    }
                    .padding(.vertical, 8)
                }.onAppear {
                    // Initialize quantity when the view appears
                    quantity = Int(cartItem.quantity)
                    
                }

            
        } else {
            // Handle the case where cartItem.relationship is nil
            Text("Product details unavailable")
        }
    }
}



