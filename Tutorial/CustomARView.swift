//
//  CustomARView.swift
//  Tutorial
//
//  Created by Tim on 2020-06-11.
//  Copyright © 2020 Tim. All rights reserved.
//

import Foundation
import RealityKit
import ARKit
import FocusEntity

class CustomARView: ARView, FEDelegate {
    func toTrackingState() {
        print("Tracking...")
    }
    
    func toInitializingState() {
        print("Initializing state...")
    }
    
    func setupARView() {

       let arView = ARView(frame: .zero)
           
       let config = ARWorldTrackingConfiguration()
       config.planeDetection = [.horizontal, .vertical]
       config.environmentTexturing = .automatic
       // LiDAR
       if #available(iOS 13.4, *) {
           if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
               config.sceneReconstruction = .mesh
           }
       } else {
           // Fallback on earlier versions
       }
       
       arView.session.run(config)
    
    }
    
    let focusSquare = FESquare()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        //Configuration
        focusSquare.viewDelegate = self
        focusSquare.delegate = self
        focusSquare.setAutoUpdate(to: true)
        
        self.setupARView()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

