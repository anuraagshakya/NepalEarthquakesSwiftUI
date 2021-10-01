//
//  EarthquakeLoader.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag Shakya on 01.10.21.
//

import Foundation

protocol EarthquakeLoader {
    var isLoading: Bool { get }
    func loadEarthquakes(completion: @escaping ((Result<[Earthquake], Error>) -> Void))
}

final class EarthquakeLoaderDefault: EarthquakeLoader {
    private var urlSession = URLSession.shared
    
    private var url: URL {
        var urlcomponents = URLComponents()
        urlcomponents.scheme = "https"
        urlcomponents.host = "earthquake.usgs.gov"
        urlcomponents.path = "/fdsnws/event/1/query"
        urlcomponents.queryItems = [
            URLQueryItem(name: "format", value: "geojson"),
            URLQueryItem(name: "starttime", value: "2010-01-01"),
            URLQueryItem(name: "minlatitude", value: "26.4"),
            URLQueryItem(name: "maxlatitude", value: "30.5"),
            URLQueryItem(name: "minlongitude", value: "80"),
            URLQueryItem(name: "maxlongitude", value: "88.2")
        ]
        
        return urlcomponents.url!
    }
    
    private enum ErrorTypes {
        case noData
        
        var error: Error {
            let domain = "EarthquakeLoaderDefault"
            switch self {
            case .noData:
                return NSError(domain: domain, code: 1001, userInfo: [NSLocalizedDescriptionKey: "No data"])
            }
        }
    }
    
    var isLoading = false
    
    func loadEarthquakes(completion: @escaping ((Result<[Earthquake], Error>) -> Void)) {
        isLoading = true
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer {
                self.isLoading = false
            }
            
            if let safeError = error {
                completion(.failure(safeError))
            }
            
            guard let safeData = data else {
                completion(.failure(ErrorTypes.noData.error))
                return
            }
            
            do {
                let list = try JSONDecoder().decode(EarthquakesList.self, from: safeData)
                completion(.success(list.features))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct EarthquakeLoaderDebug: EarthquakeLoader {
    var isLoading = false
    
    func loadEarthquakes(completion: @escaping ((Result<[Earthquake], Error>) -> Void)) {
        let earthquakes: [Earthquake] = load("earthquakeData.json")
        completion(.success(earthquakes))
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
}
