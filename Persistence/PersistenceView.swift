import SwiftUI
import RealityKit
import ARKit

struct PersistenceContentView : View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        VStack {
            
            HStack {
                Text(vm.worldMapStatus.rawValue)
                    .font(.largeTitle)
            }.frame(maxWidth: .infinity, maxHeight: 60)
                .background(.blue)
            
            PersistenceARViewContainer(vm: vm).edgesIgnoringSafeArea(.all)
            HStack {
                Button("SAVE") {
                    vm.onSave()
                }.buttonStyle(.borderedProminent)
                
                Button("CLEAR") {
                    vm.onClear()
                }.buttonStyle(.bordered)
                
            }
        }.alert("ARWorldMap has been saved!", isPresented: $vm.isSaved) {
            Button(role: .cancel, action: { }) {
                Text("OK")
            }
        }
    }
}

struct PersistenceARViewContainer: UIViewRepresentable {
    
    let vm: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        
        ARVariables.arView = ARView(frame: .zero)
        ARVariables.arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(PrestenceCoordinator.onTap)))
        context.coordinator.arView =   ARVariables.arView
        ARVariables.arView.session.delegate = context.coordinator
        
        vm.onSave = {
            context.coordinator.saveWorldMap()
            print("gjhugk")
        }
        
        vm.onClear = {
            context.coordinator.clearWorldMap()
        }
        
        context.coordinator.loadWorldMap()
        return   ARVariables.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> PrestenceCoordinator {
        Coordinator(vm: vm)
    }
    
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        PersistenceContentView()
//    }
//}
#endif
import Foundation

enum WorldMapStatus: String  {
    case notAvailable = "Not Available"
    case limited = "Limited"
    case extending = "Extending"
    case mapped = "Mapped"
}

class ViewModel: ObservableObject {
    var onSave: () -> Void = { }
    var onClear: () -> Void = { }
    @Published var isSaved: Bool = false
    @Published var worldMapStatus: WorldMapStatus = .notAvailable
    //Published selectedFurniture
    @Published var selectedFurniture:String = ""
}
