//
//  ProductDetailsView.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import SwiftUI

struct ProductDetailsView: View {
    @ObservedObject var viewModel: ProductViewModel
    @ObservedObject var cartViewModel: CartViewModel

    var product: Product
    @State private var quantity: Int32 = 1
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(product.image ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name ?? "")
                        .font(.title)
                    
                    Text("$\(product.price)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Button(action: {
                    if quantity <= 0 {
                        showAlert = true
                    } else {
                        viewModel.addProductToCart(product: product, quantity: quantity)
                        showAlert = true // Show popup upon successful addition to cart
                    }
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Product Details", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Product added to cart."), dismissButton: .default(Text("OK")))
        }
    }
}
