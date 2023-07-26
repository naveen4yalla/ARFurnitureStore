//
//  Coordinator.swift
//  Archeality
//
//  Created by Anurag Kaki.
//

import Foundation
import RealityKit
import ARKit 

class Coordinator {
    
    var arView: ARView?
    var mainScene: Experience.MainScene
    var vm: FurnitureViewModel
    
    init(vm: FurnitureViewModel) {
        self.vm = vm
        self.mainScene = try! Experience.loadMainScene()
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else {
            return
        }
        
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            
            let anchor = AnchorEntity(raycastResult: result)
            print(vm.selectedFurniture)
            guard let entity = mainScene.findEntity(named: vm.selectedFurniture)
            else {
                return
            }
            entity.position = SIMD3(0,0,0)
            
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
        }
        
    }
    
}
