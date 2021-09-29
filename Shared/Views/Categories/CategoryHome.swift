//
//  CategoryHome.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 29.09.21.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Earthquake.Category.allCasesSorted, id: \.self) { category in
                    NavigationLink(destination: EarthquakeList(
                                    earthquakes: modelData.earthquakes.filter { $0.category == category })
                                    .navigationTitle(category.rawValue)
                    ) {
                        CategoryRow(category: category)
                    }
                }
            }
            .navigationTitle("Categories")
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}
