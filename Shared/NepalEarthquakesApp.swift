//
//  NepalEarthquakesApp.swift
//  Shared
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

@main
struct NepalEarthquakesApp: App {
    // This probably is not the proper place to call the `load` function
    @StateObject private var modelData: ModelData = {
        let modelData = ModelData()
        modelData.load()
        return modelData
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }

}
