//
//  Model.swift
//  Tutorial
//
//  Created by Tim on 2020-06-11.
//  Copyright © 2020 Tim. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
// Async event-driven framework
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        
        // Load Thumbnail
        self.image = UIImage(named: modelName)!
        
        // Asynchronously load the model
        let filename = modelName + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            // subscription pipe
            .sink(receiveCompletion: {
                loadCompletion in
                // Handle
                print("loadCompletion: \(loadCompletion)")
            }, receiveValue: {
                
                // Successfully loaded model entity
                modelEntity in
                self.modelEntity = modelEntity
                print("Successfully loaded \(modelEntity)")
            })
        
    }
}

