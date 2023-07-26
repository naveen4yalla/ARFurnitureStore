//
//  ContentView.swift
//  Archeality
//
//  Created by Anurag Kaki on 1/10/23.
//

import SwiftUI
import RealityKit
import ARKit
//struct ContentView : View {
//
//
//    let furnitures = ["sofa", "chair", "table", "armoire"]
//
//    var body: some View {
//        NavigationStack {
//            ForEach(furnitures, id: \.self) { name in
//                NavigationLink {
//                    tempView(item:[name])
//                } label: {
//                    Text(name)
//                }
//            }
//        }
//    }
//}

//struct tempView: View{
//    var item :[String]
//    @StateObject private var vm = FurnitureViewModel()
//    var body: some View{
//        VStack {
//            ARViewContainer(vm:vm).edgesIgnoringSafeArea(.all)
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(item, id: \.self) { name in
//                        Image(name)
//                            .resizable()
//                            .frame(width: 100, height: 100)
//                            .border(.white, width: vm.selectedFurniture == name ? 1.0: 0.0)
//                            .onTapGesture {
//                                vm.selectedFurniture = name
//                            }
//                    }
//                }
//            }
//        }
//        
//    }
//}

struct ARViewContainer: UIViewRepresentable {
    
    let vm: FurnitureViewModel
    
    func makeUIView(context: Context) -> ARView {
        
        ARVariables.arView = ARView(frame: .zero)
        
        let session =   ARVariables.arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        
        ARVariables.arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped)))
        context.coordinator.arView =   ARVariables.arView
        ARVariables.arView.addCoachingOverlay()
        return   ARVariables.arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(vm: vm)
    }
    
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#endif


struct MainTabView : View{
    @ObservedObject var cart: Cart
    @State public var sheetView:Bool = false
    @State public   var shouldPresentSheet = false
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        ZStack{
            if logStatus==false{
//            if sheetView == false && UserDefaults.standard.bool(forKey: "Tap") == false && logStatus==false{
              //Sheetview is also not required when appstorage check is enabled 
                IntroHome(shouldPresentSheet: $shouldPresentSheet,sheetView: $sheetView)
            }
            else{
                TabView {
                    NavigationStack {
                        Home()
                    }.preferredColorScheme(.light)
                       
                        .tabItem {
                            Label("AR Objects", systemImage: "pencil.circle")
                            Text("Editor")
                        }
                    
                    ReceiptStarting()
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                            Text("Notes")
                        }
                    
                    ZStack{
                        MeasureARViewContainer()
                        Spacer()
                        CaptureButton()
                        
                    }
                    .tabItem {
                        Label("Measure", systemImage: "ruler.fill")
                        Text("Measure")
                    }
                    ZStack{
                    PersistenceContentView()
                        Spacer()
                        CaptureButton()
                }
                        .tabItem{
                            Label("Persistence", systemImage: "scale.3d")
                                  Text("Measure")
                            
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                            Text("Profile")
                        }
                    // return ARViewContainer().edgesIgnoringSafeArea(.all)
                }

            }
        }.environmentObject(cart)
    }
        
    }
    

import SwiftUI

/// Page Intro Model
struct PageIntro: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
    var displaysAction: Bool = false
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "Page 1", title: "Measure Your Surroundings", subTitle: "Measure the distances with coordinates"),
    .init(introAssetImage: "Page 2", title: "Design Your Room", subTitle: "Try out different furnitures in your surroundings "),
    .init(introAssetImage: "Page 3", title: "Capture Your Ideas", subTitle: "Save the design that you created", displaysAction: true),
]
struct CustomIndicatorView: View {
    /// View Properties
    var totalPages: Int
    var currentPage: Int
    var activeTint: Color = .black
    var inActiveTint: Color = .gray.opacity(0.5)
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) {
                Circle()
                    .fill(currentPage == $0 ? activeTint : inActiveTint)
                    .frame(width: 4, height: 4)
            }
        }
    }
}
struct IntroView<ActionView: View>: View {
    @Binding var intro: PageIntro
    var size: CGSize
    var actionView: ActionView
    
    init(intro: Binding<PageIntro>, size: CGSize, @ViewBuilder actionView: @escaping () -> ActionView) {
        self._intro = intro
        self.size = size
        self.actionView = actionView()
    }
    
    /// Animation Properties
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false
    var body: some View {
        VStack {
            /// Image View
            GeometryReader {
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                   
                    
            }
            /// Moving Up
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            /// Tile & Action's
            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                
                Text(intro.title)
                    .font(.system(size: 40))
                    .fontWeight(.black)
                
                Text(intro.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                
                if !intro.displaysAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        /// Custom Indicator View
                        CustomIndicatorView(totalPages: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            changeIntro()
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical, 15)
                                .background {
                                    Capsule()
                                        .fill(.black)
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    /// Action View
                    actionView
                        .offset(y: showView ? 0 : size.height / 2)
                        .opacity(showView ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            /// Moving Down
            .offset(y: showView ? 0 : size.height / 2)
            .opacity(showView ? 1 : 0)
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        /// Back Button
        .overlay(alignment: .topLeading) {
            /// Hiding it for Very First Page, Since there is no previous page present
            if intro != pageIntros.first {
                Button {
                    changeIntro(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding(10)
                /// Animating Back Button
                /// Comes From Top When Active
                .offset(y: showView ? 0 : -200)
                /// Hides by Going back to Top When In Active
                .offset(y: hideWholeView ? -200 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0).delay(0.1)) {
                showView = true
            }
        }
    }
    
    /// Updating Page Intro's
    func changeIntro(_ isPrevious: Bool = false) {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            /// Updating Page
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0 : index != pageIntros.count - 1) {
                intro = isPrevious ? pageIntros[index - 1] : pageIntros[index + 1]
            } else {
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
            }
            /// Re-Animating as Split Page
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
                showView = true
            }
        }
    }
    
    var filteredPages: [PageIntro] {
        return pageIntros.filter { !$0.displaysAction }
    }
}
struct IntroHome: View {
    @Binding var shouldPresentSheet:Bool
    @Binding var sheetView:Bool
    /// View Properties
    @State private var activeIntro: PageIntro = pageIntros[0]
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            IntroView(intro: $activeIntro, size: size) {
                /// User Login/Signup View
                VStack(spacing: 10) {
                    /// Custom TextField
//                    CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))
//                    CustomTextField(text: $emailID, hint: "Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
//
                    Spacer(minLength: 10)
                    
                    Button {
                        sheetView = true
                        UserDefaults.standard.set(self.sheetView, forKey: "Tap")
                        
                        print(UserDefaults.standard.bool(forKey: "Tap"))
                        shouldPresentSheet.toggle()
                    } label: {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(.black)
                            }
                    }
                }
                .padding(.top, 25)
            }
        }
        .padding(15)
        /// Manual Keyboard Push
        .offset(y: -keyboardHeight)
        /// Disabling Native Keyboard Push
        .ignoresSafeArea(.keyboard, edges: .all)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
            if let info = output.userInfo, let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                keyboardHeight = height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: keyboardHeight)
        .sheet(isPresented: $shouldPresentSheet) {
                            
                        } content: {
                            Login()
                        }
    }
    
}


struct ARVariables{
    static var arView: ARView!
}



struct CaptureButton: View {
    var body: some View {
        HStack{
            Spacer()
            Button {
                
                ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                    
                    // Compress the image
                    let compressedImage = UIImage(data: (image?.pngData())!)
                    // Save in the photo album
                    UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                }
                
            } label: {
                Image(systemName: "camera")
                    .frame(width:60, height:60)
                    .font(.title)
                    .background(.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding()
            }
        }
    }
}
