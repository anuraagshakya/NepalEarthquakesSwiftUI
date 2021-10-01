//
//  ContentView.swift
//  Shared
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .categories
    
    enum Tab {
        case categories
        case lists
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem {
                    Label("Categories", systemImage: "list.bullet")
                }
                .tag(Tab.categories)
            
            Lists()
                .tabItem {
                    Label("Top", systemImage: "star")
                }
                .tag(Tab.lists)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData.debug)
    }
}
