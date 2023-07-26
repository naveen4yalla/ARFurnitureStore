//
//  Product.swift
//  Archeality
//
//  Created by Anurag Kaki on 3/20/23.
//

import SwiftUI

/// Product Model & Sample Products
struct Product: Identifiable,Hashable {
    var id: UUID = UUID()
    var type: ProductType
    var title: String
    var subtitle: String
    var price: Int
    var productImage: String = ""
}

enum ProductType: String,CaseIterable {
    case chair = "Chairs"
    case music = "Instruments"
    case tables = "Tables"
    case sofa = "Couches"
    case tv = "Television"
    //case airpods = "lamps"
    
    var tabID: String {
        /// Creating Another UniqueID for Tab Scrolling
        return self.rawValue + self.rawValue.prefix(4)
    }
}

var products: [Product] = [
    /// chair
    Product(type: .chair, title: "Wooden Chair", subtitle: "Vintage look", price: 199,productImage: "chair"),
    Product(type: .chair, title: "Modern Chair", subtitle: "Red Chair", price: 99,productImage: "m_chair"),
    
    /// tables
    Product(type: .tables, title: "Modern Desk", subtitle: "Black Desk", price: 599, productImage: "m_desk"),
    Product(type: .tables, title: "Office Table", subtitle: "Wooden Texture", price: 699, productImage: "office_table"),
    Product(type: .tables, title: "Box", subtitle: "Treasure Box", price: 199, productImage: "Box"),
    Product(type: .tables, title: "Wooden Shelf", subtitle: "Books Shelf", price: 99, productImage: "shelf"),
    Product(type: .tables, title: "Wooden Table", subtitle: "Classic Table", price: 89, productImage: "w_table"),
    Product(type: .tables, title: "Organizer", subtitle: "Wooden Texture", price: 59, productImage: "armoire"),
    /// tv
    Product(type: .tv, title: "TV", subtitle: "Vintage TV", price: 299, productImage: "TV"),
    ///music
    Product(type: .music, title: "Gramophone", subtitle: "Artifact", price: 499, productImage: "Gramaphone"),
    Product(type: .music, title: "Guitar", subtitle: "Electric Guitar", price: 299, productImage: "Guitar"),
    ///sofa
    Product(type: .sofa, title: "Sofa", subtitle: "Red Sofa", price: 199, productImage: "sofa"),
    
]


