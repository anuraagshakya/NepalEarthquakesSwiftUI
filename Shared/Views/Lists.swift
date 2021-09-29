//
//  Lists.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 29.09.21.
//

import SwiftUI

struct Lists: View {
    @EnvironmentObject var modelData: ModelData
    
    private static let listLength = 20
    
    private var earthquakesStrongestFirst: [Earthquake] {
        modelData.earthquakes.sorted { first, second -> Bool in
            first.mag > second.mag
        }
    }
    
    private var earthquakesNewestFirst: [Earthquake] {
        modelData.earthquakes.sorted { first, second -> Bool in
            first.date > second.date
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: EarthquakeList(earthquakes: earthquakesStrongestFirst)
                    .navigationTitle("Strongest"),
                    label: {
                        GenericRow(title: "Strongest", subtitle: "ordered by the strongest earthquakes to hit Nepal since 2010")
                    })
                
                NavigationLink(
                    destination: EarthquakeList(earthquakes: earthquakesNewestFirst)
                    .navigationTitle("Latest"),
                    label: {
                        GenericRow(title: "Latest", subtitle: "view the latest earthquakes to hit Nepal as they happen")
                    })
            }
            .navigationTitle("Lists")
        }
    }
}

struct Lists_Previews: PreviewProvider {
    static var previews: some View {
        Lists()
            .environmentObject(ModelData())
    }
}
