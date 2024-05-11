//
//  ProductListViewModel.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import SwiftUI

struct ProductListView: View {
      @ObservedObject var viewModel: ProductViewModel
      @ObservedObject var cartViewModel: CartViewModel

       @State private var selectedCategory: String = ""

    var body: some View {
         NavigationView {
             VStack {
                 // Category picker
                 Picker("Category", selection: $selectedCategory) {
                     Text("All").tag("") // Tag for all categories
                     ForEach(viewModel.categories, id: \.self) { category in
                         Text(category).tag(category)
                     }
                 }
                 .pickerStyle(SegmentedPickerStyle())
                 .padding(.horizontal)
                 
                 // List of products based on the selected category
                 List(viewModel.products) { product in
                     if selectedCategory.isEmpty || product.category == selectedCategory {
                         NavigationLink(destination: ProductDetailsView(viewModel: viewModel, cartViewModel: cartViewModel, product: product)) {
                             ProductRowView(product: product)
                         }
                     }
                 }
                 .onAppear {
                     // Fetch products initially without filtering by category
                     viewModel.fetchProducts()
                     viewModel.fetchCategories()
                 }
             }
         }
     }
 }

struct ProductRowView: View {
    var product: Product
    
    var body: some View {
        LazyHStack {
            if let imageName = product.image,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            LazyVStack(alignment: .leading) {
                Text(product.name ?? "")
                    .font(.headline)
                
                Text("$\(product.price))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}


