//
//  ARView+Extensions.swift
//  Archeality
//
//  Created by Anurag Kaki.
//

import Foundation
import RealityKit
import ARKit

extension ARView {
    
    func addCoachingOverlay() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        self.addSubview(coachingOverlay)
        
    }
    
}
