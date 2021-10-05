//
//  MagnitudeIcon.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 29.09.21.
//

import SwiftUI

struct MagnitudeIcon: View {
    var earthquake: Earthquake
    
    var body: some View {
        Text(String(earthquake.mag))
            .font(.title3)
            .bold()
            .padding()
            .background(earthquake.category.color)
            .clipShape(Circle())
    }
}

struct MagnitudeIcon_Previews: PreviewProvider {
    static var previews: some View {
        MagnitudeIcon(earthquake: ModelData.withMockedEarthquakes.state.earthquakes[0])
    }
}
