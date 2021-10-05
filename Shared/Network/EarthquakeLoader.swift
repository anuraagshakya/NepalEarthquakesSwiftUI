//
//  EarthquakeLoader.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag Shakya on 01.10.21.
//

import Foundation

final class EarthquakeLoader {
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
        
    func loadEarthquakes(completion: @escaping ((Result<[Earthquake], Error>) -> Void)) {
        urlSession.dataTask(with: url) { data, response, error in
            if let safeError = error {
                completion(.failure(safeError))
            }
            
            guard let safeData = data else {
                completion(.failure(ErrorTypes.noData.error))
                return
            }
            
            do {
                let list = try JSONDecoder().decode(EarthquakeReseponse.self, from: safeData)
                completion(.success(list.features))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
