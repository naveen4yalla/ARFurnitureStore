//
//  CartView.swift
//  Archeality
//
//  Created by Naveen Yalla on 5/3/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: Cart
    var body: some View {
        NavigationView {
            VStack{
                List($cart.cartItems) { $cartItem in
                    
                    CartItemRow(cartItem:  $cartItem)}
                CartSummary(subtotal: $cart.subtotal)
                shippingView()
                RoundedButton(imageName: "creditcard", text: "Continue").padding()
            }.navigationTitle("Cart")
        }
    }
}
     

struct shippingView: View{
    @AppStorage("Address") private var ad : String = ""
    @AppStorage("Street Name") private var sn : String = ""
    @AppStorage("pincode") private var pn : String = ""
    @AppStorage("country") private var co : String = ""
    var body: some View{
        VStack(alignment:.leading){
            HStack(){
                VStack(alignment:.leading){
                    Text("Shipping Address").bold()
                    Text(ad+","+sn+","+pn)
                    Text(co)
                   
                }
                
                Spacer()
                
                
                
                
            }.padding(.all)
        }
    }
}

//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartView()
//    }
//}
struct CartItemRow: View {
   @Binding var cartItem: CartItem
   var body: some View {
   HStack {
       Image(cartItem.product.productImage)
     .resizable()
     .frame(width: 100, height: 100)
      VStack(alignment: .leading) {
          Text(cartItem.product.title).fontWeight(.semibold)
      }
      Spacer()
      Text("\(cartItem.count)")
   }
}}

struct CartSummary: View {
   @Binding var subtotal: Double
   var body: some View {
   VStack {
//      Button(action: { print("We'll implement promo codes later")
//      }) { Text("Add promo code").padding()}
      HStack {
         Text("Summary").bold()
         Spacer()
         VStack {
            HStack {
               Text("Subtotal")
               Spacer()
               Text(String(format: "$%.2f", subtotal))
            }
            HStack {
               Text("Taxes")
               Spacer()
               Text(String(format: "$%.2f", subtotal*0.0662))
            }
            HStack {
               Text("Total")
               Spacer()
               Text(String(format: "$%.2f", subtotal+subtotal*0.0662))
            }
         }.frame(width: 200)
      }.padding()
   }.background(Color.gray.opacity(0.1))
}}
struct RoundedButton: View {
    @EnvironmentObject var cart: Cart
   var imageName: String
   var text: String
    
   var body: some View {
   HStack {
      Image(systemName: imageName).font(.title)
      Text(text).fontWeight(.semibold).font(.title)
   }.padding().foregroundColor(.white).background(Color.black)
.cornerRadius(40)
}}
