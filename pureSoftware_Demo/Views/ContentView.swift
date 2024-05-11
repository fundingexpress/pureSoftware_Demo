//
//  ContentView.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject var productViewModel = ProductViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State private var selectedTab = 0 // Track the selected tab index
    
    var body: some View {
        NavigationView {
            VStack {
                // Tab content
                TabView(selection: $selectedTab) {
                    ProductListView(viewModel: productViewModel, cartViewModel: cartViewModel)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Products")
                        }
                        .tag(0)
                    
                    CartView(viewModel: cartViewModel)
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Cart")
                        }
                        .tag(1)
                }
                .navigationBarTitle(tabTitle(for: selectedTab)) // Set navigation title based on selected tab
                
                
            }.onAppear(
                perform: CoreDataStack.shared.insertDummyData
            )
        }
    }
    
    // Function to get the title for the selected tab
    func tabTitle(for tab: Int) -> String {
        switch tab {
        case 0:
            return "Products"
        case 1:
            return "Cart"
        default:
            return ""
        }
    }
}



