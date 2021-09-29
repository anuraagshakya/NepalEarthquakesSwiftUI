//
//  NepalEarthquakesApp.swift
//  Shared
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

@main
struct NepalEarthquakesApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
