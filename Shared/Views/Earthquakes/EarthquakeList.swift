//
//  EarthquakeList.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import SwiftUI

struct EarthquakeList: View {
    @EnvironmentObject var modelData: ModelData
    
    var sortRule: ((Earthquake, Earthquake) -> Bool)?
    var filterRule: ((Earthquake) -> Bool)?
    
    init(sortRule: ((Earthquake, Earthquake) -> Bool)? = nil,
         filterRule: ((Earthquake) -> Bool)? = nil) {
        self.sortRule = sortRule
        self.filterRule = filterRule
    }
    
    private var filteredAndSortedEarthquakes: [Earthquake] {
        var result = modelData.state.earthquakes.filter { filterRule?($0) ?? true }
        result = result.sorted { sortRule?($0, $1) ?? true }
        return result
    }
    
    var body: some View {
        switch modelData.state {
        case .failed(let error):
            VStack(spacing: 16) {
                Text("😣 Something went wrong")
                    .bold()
                Text("🤔 Perhaps this message will help figure it out 👇")
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.red)
                Button("Refresh") {
                    modelData.load()
                }
            }
            .padding()
        case .loading:
            ProgressView()
        case .loaded:
            List {
                ForEach(filteredAndSortedEarthquakes) { earthquake in
                    NavigationLink(destination: EarthquakeDetail(earthquake: earthquake)) {
                        EarthquakeRow(earthquake: earthquake)
                    }
                }
            }
        }
    }
}

struct EarthquakeList_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeList()
            .environmentObject(ModelData.withMockedEarthquakes)
        EarthquakeList()
            .environmentObject(ModelData(state: .loading))
        EarthquakeList()
            .environmentObject(ModelData(state: .failed(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "This is the error message."]))))
    }
}
