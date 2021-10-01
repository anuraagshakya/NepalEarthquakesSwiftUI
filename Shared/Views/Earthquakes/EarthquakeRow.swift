//
//  EarthquakeRow.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

struct EarthquakeRow: View {
    var earthquake: Earthquake
    
    var body: some View {
        HStack {
            MagnitudeIcon(earthquake: earthquake)
            VStack(alignment: .leading) {
                Text(earthquake.place)
                    .bold()
                if let date = earthquake.date {
                    Text(date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake: ModelData.debug.earthquakes[0])
    }
}
