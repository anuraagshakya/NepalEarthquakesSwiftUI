//
//  EarthquakeList.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

struct EarthquakeList: View {
    var earthquakes: [Earthquake]
    
    var body: some View {
        List {
            ForEach(earthquakes) { earthquake in
                NavigationLink(destination: EarthquakeDetail(earthquake: earthquake)) {
                    EarthquakeRow(earthquake: earthquake)
                }
            }
        }
    }
}

struct EarthquakeList_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeList(earthquakes: ModelData.debug.earthquakes)
    }
}
