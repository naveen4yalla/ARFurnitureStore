//
//  cartModal.swift
//  Archeality
//
//  Created by Naveen Yalla on 5/3/23.
//
import Foundation
class Cart: ObservableObject {
    @Published var cartItems: [CartItem]
    var subtotal = 0.0
    init() {
        self.cartItems = []
    }
    
    func addProduct(product: Product){
        var addNewProduct = true
        let price = Double(product.price) ?? 0.0
        subtotal = subtotal + price
        for (index, item) in cartItems.enumerated() {
            if item.product.id == product.id {
                cartItems[index].count = cartItems[index].count + 1
                addNewProduct = false
            }
        }
        if addNewProduct {
            cartItems.append(CartItem(product: product, count: 1))
            print(subtotal)
        }
        
        
        
        
    }
}


struct CartItem: Identifiable {
   var id: String
   var product: Product
   var count: Int
init(product: Product, count: Int) {
   self.id = UUID().uuidString
   self.product = product
   self.count = count
}}
