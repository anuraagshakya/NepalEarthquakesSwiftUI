//
//  EarthquakeDetail.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

struct EarthquakeDetail: View {
    @State private var showingWebDetail = false
    var earthquake: Earthquake
    
    var body: some View {
        VStack {
            MapView(coordinate: earthquake.locationCoordinates)
                .ignoresSafeArea(edges: .top)
            
            VStack(alignment: .leading) {
                Text(earthquake.place)
                    .bold()
                    .font(.title)
                
                if let date = earthquake.date {
                    Text(date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Magnitude")
                            .font(.title2)
                            .bold()
                        
                        Text(String(earthquake.mag))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Depth")
                            .font(.title2)
                            .bold()
                        
                        Text("\(String(earthquake.location.depth)) km")
                    }
                }
                .padding(.top, 16)
                
                if let url = URL(string: earthquake.urlString) {
                    Button("Show details") {
                        showingWebDetail.toggle()
                    }
                    .sheet(isPresented: $showingWebDetail) {
                        NavigationView {
                            WebSheetView(request: URLRequest(url: url))
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button("Done") {
                                            showingWebDetail.toggle()
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 4)
                }

            }
            .padding()
        }
    }
}

struct EarthquakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeDetail(earthquake: ModelData.withMockedEarthquakes.state.earthquakes[0])
    }
}
