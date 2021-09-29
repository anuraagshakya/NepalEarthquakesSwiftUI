//
//  ModelData.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import Combine
import Foundation

final class ModelData: ObservableObject {
    @Published var earthquakes: [Earthquake] = {
        var allEarthquakes: [Earthquake] = load("earthquakeData.json")
        return allEarthquakes.filter { $0.place.contains("Nepal") }
    }()
    
    var categories: [String: [Earthquake]] {
        Dictionary(grouping: earthquakes) {
            $0.category.rawValue
        }
    }
}

private func load<T: Decodable>(_ filename: String) -> T {
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
