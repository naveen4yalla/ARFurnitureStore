//
//  ARViewContainer.swift
//  Archeality
//
//  Created by Anurag Kaki on 2/15/23.
//

struct MeasureARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        //let arView = ARView(frame: .zero)
        ARVariables.arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        ARVariables.arView.session.run(config)
        
        ARVariables.arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(MeasureCoordinator.handleTap)))
        context.coordinator.arView = ARVariables.arView
        context.coordinator.setupUI()
        
        ARVariables.arView.measureAddCoachingOverlay()
        
        return ARVariables.arView
    }
    
    func makeCoordinator() -> MeasureCoordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
import Foundation
import ARKit
import RealityKit
import SwiftUI

extension ARView {
    
    func measureAddCoachingOverlay() {
        let coachingView = ARCoachingOverlayView()
        coachingView.goal = .horizontalPlane
        coachingView.session = self.session
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingView)
    }
    
}

