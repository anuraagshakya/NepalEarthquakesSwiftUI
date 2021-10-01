//
//  ModelData.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import Combine
import Foundation

final class ModelData: ObservableObject {
    var earthquakeLoader: EarthquakeLoader

    @Published var earthquakes: [Earthquake] = []

    static var debug = ModelData(earthquakeLoader: EarthquakeLoaderDebug())
        
    init(earthquakeLoader: EarthquakeLoader = EarthquakeLoaderDefault()) {
        self.earthquakeLoader = earthquakeLoader
        earthquakeLoader.loadEarthquakes { result in
            switch result {
            case .success(let loadedEarthquakes):
                DispatchQueue.main.async { [weak self] in
                    let nepalEarthquakes = loadedEarthquakes.filter { $0.place.contains("Nepal") }
                    self?.earthquakes = nepalEarthquakes
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var categories: [String: [Earthquake]] {
        Dictionary(grouping: earthquakes) {
            $0.category.rawValue
        }
    }
}
