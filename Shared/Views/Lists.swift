//
//  Lists.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 29.09.21.
//

import SwiftUI

struct Lists: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: EarthquakeList(sortRule: { first, second -> Bool in
                        first.mag > second.mag
                    })
                    .navigationTitle("Strongest"),
                    label: {
                        GenericRow(title: "Strongest", subtitle: "ordered by the strongest earthquakes to hit Nepal since 2010")
                    })
                
                NavigationLink(
                    destination: EarthquakeList(sortRule: { first, second -> Bool in
                        first.date > second.date
                    })
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
            .environmentObject(ModelData.withMockedEarthquakes)
    }
}
