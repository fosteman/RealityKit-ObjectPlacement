//
//  ContentView.swift
//  Tutorial
//
//  Created by Tim on 2020-06-10.
//  Copyright © 2020 Tim. All rights reserved.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    private var models: [String] = {
       // Dynamic filename reading
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath,
            let files = try? filemanager.contentsOfDirectory(atPath: path)
            else {
                // If any file is nil
                return []
        }
        
        var availableModels: [String] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelname = filename.replacingOccurrences(of: ".usdz", with: "")
            
            availableModels.append(modelname)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            
            ModelPickerView(models: self.models)
            
            PlacementButtonsView()
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    var models: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                //
                ForEach(0 ..< self.models.count) {
                    index in
                    Button(action: {
                        print("Debug selected model: \(self.models[index])" )
                    }, label: {
                        Image(uiImage: UIImage(named: self.models[index])!)
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
    var body: some View {
        HStack {
                // Cancel Button
                Button(action: {
                    print("Debug: Cancel Model Placement")
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
                    print("Debug: Confirm Model Placement")
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


