//
//  ContentView.swift
//  Tutorial
//
//  Created by Tim on 2020-06-10.
//  Copyright © 2020 Tim. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit
import WebKit

struct ContentView : View {
    
    @State private var isPlacing = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?

    
    private var models: [Model] = {
       // Dynamic filename reading
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath,
            let files = try? filemanager.contentsOfDirectory(atPath: path)
            else {
                // If any file is nil
                return []
        }
        
        var availableModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelname = filename.replacingOccurrences(of: ".usdz", with: "")
            
            let model = Model(modelName: modelname)
            
            availableModels.append(model)
        }
        
        print("availableModels count: \(availableModels.count)")
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: $modelConfirmedForPlacement)
            
            
            
            
            if self.isPlacing {
                PlacementButtonsView(isPlacing: self.$isPlacing, selectedModel: self.$selectedModel, modelConfirmedForPlacement: $modelConfirmedForPlacement)
            }
            else {
                // Binding State
                ModelPickerView(isPlacing: self.$isPlacing, selectedModel: self.$selectedModel, models: self.models)
            }
    }
}
    


struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    
    func makeUIView(context: Context) -> ARView {
        let view = CustomARView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            print("Debug: adding \(model.modelName) to scene")
                
            if let modelEntity = model.modelEntity {
                let anchorEntity = AnchorEntity(plane: .any)
                // Cloning
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                
                uiView.scene.addAnchor(anchorEntity)
            }
            else {
                print("Unable to load model entity \(model.modelName)")
            }
            

                

            

            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
    
}

struct ModelPickerView: View {
    @Binding var isPlacing: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    // WEbView
    // var modelMaslo: WKWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 500), configuration: WKWebViewConfiguration())

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                //
                ForEach(0 ..< self.models.count) {
                    index in
                    Button(action: {
                        print("Debug: selected \(self.models[index].modelName)" )
                        
                        // Switch UI
                        self.isPlacing = true
                        
                        // Select the model
                        self.selectedModel = self.models[index]
                        
                        
                    }, label: {
                        Image(uiImage: self.models[index].image)
                        .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                    })
                    .buttonStyle(PlainButtonStyle())
                        .background(Color.white)
                    .cornerRadius(12)
                    
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonsView: View {
    // UI
    @Binding var isPlacing: Bool
    func resetPlacementParameters() {
        self.isPlacing = false
        self.selectedModel = nil // null
     }
    
    //
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    // return (<div><div/>) <-- HTML
    var body: some View {
        HStack {
                // Cancel Button
                Button(action: {
                    print("Debug: Cancel Model Placement")
                    
                    /// Switch UI
                    self.resetPlacementParameters()
                    
                   
                }, label: {
                    Image(systemName: "xmark")
                    .resizable()
                    .frame(height: 60)
                    .aspectRatio(1/1, contentMode: .fit)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                })
                
                //Confirmation Button
                Button(action: {
                    // set selected model
                    self.modelConfirmedForPlacement = self.selectedModel
                    
                    print("Debug: Confirm \(String(describing: self.selectedModel)) Placement")
                    
                    self.resetPlacementParameters()
                }, label: {
                    Image(systemName: "checkmark")
                    .resizable()
                    .frame(height: 60)
                    .aspectRatio(1/1, contentMode: .fit)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                })
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


