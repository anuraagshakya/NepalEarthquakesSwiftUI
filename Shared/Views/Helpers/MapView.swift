//
//  MapView.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI
import MapKit

private struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [epicentreMarker]) { mapMarker in
            mapMarker.location
        }
        .onAppear {
            setRegion(coordinate)
        }
    }
    
    private var epicentreMarker: Marker {
        Marker(location: MapMarker(coordinate: coordinate,
                                   tint: .red))
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 2.0,
                                   longitudeDelta: 2.0)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(
                    latitude: 34.011_286,
                    longitude: -116.166_868)
        )
    }
}
