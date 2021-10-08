//
//  ModelData.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import Combine
import Foundation

enum AppState {
    case loading
    case failed(Error)
    case loaded([Earthquake])
    
    var earthquakes: [Earthquake] {
        switch self {
        case .loading, .failed:
            return []
        case .loaded(let earthquakes):
            return earthquakes
        }
    }
}

final class ModelData: ObservableObject {
    @Published var state: AppState
    
    private var earthquakeLoader = EarthquakeLoader()
        
    init(state: AppState = .loaded([])) {
        self.state = state
    }
    
    func load() {
        self.state = .loading
        earthquakeLoader.loadEarthquakes { result in
            switch result {
            case .success(let loadedEarthquakes):
                DispatchQueue.main.async { [weak self] in
                    let nepalEarthquakes = loadedEarthquakes.filterForNepal()
                    let nepalEarthquakesSortedByRecency = nepalEarthquakes.sorted { $0.date > $1.date }
                    self?.state = .loaded(nepalEarthquakesSortedByRecency)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.state = .failed(error)
                }
            }
        }
    }
    
    var categories: [String: [Earthquake]] {
        Dictionary(grouping: state.earthquakes) {
            $0.category.rawValue
        }
    }
}

private extension Array where Element == Earthquake {
    func filterForNepal() -> [Earthquake] {
        filter { $0.place.contains("Nepal") }
    }
}

// Extension that simplifies mocking the model for SwiftUI previews
extension ModelData {
    
    static var withMockedEarthquakes: ModelData {
        ModelData(state: .loaded(mockEarthquakes.filterForNepal()))
    }
    
    private static var mockEarthquakes: [Earthquake] {
        Self.loadFromFile("earthquakeData.json")
    }
    
    private static func loadFromFile<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find file named \(filename)")
        }
        
        do {
            try data = Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
}
