//
//  Earthquake.swift
//  NepalEarthquakes
//
//  Created by Anuraag on 26.09.21.
//

import Foundation
import CoreLocation
import SwiftUI

// Model for Earthquake data derived from GeoJSON format defined by the USGS
// here: https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php
struct Earthquake: Identifiable {
    var id: UUID
    var title: String
    var place: String
    var date: Date
    var mag: Float
    var urlString: String
    
    var location: Coordinates
    struct Coordinates: Codable {
        var longitude: Float
        var latitude: Float
        var depth: Float
    }
    
    var locationCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(location.latitude),
                                      longitude: Double(location.longitude))
    }
    
    var category: Category {
        if (mag <= 4.9) {
            return .minor
        } else if (mag <= 5.9) {
            return .moderate
        } else if (mag <= 6.9) {
            return .strong
        } else {
            return .major
        }
    }
    
    enum Category: String {
        case minor = "Minor"
        case moderate = "Moderate"
        case strong = "Strong"
        case major = "Major"
        
        var description: String {
            switch self {
            case .minor:
                return "may cause minor breakage of objects; may be felt by people"
            case .moderate:
                return "some damage to weak structures"
            case .strong:
                return "moderate damage in populated areas"
            case .major:
                return "serious damage over large areas; loss of life"
            }
        }
        
        var color: Color {
            switch self {
            case .minor:
                return .green
            case .moderate:
                return .yellow
            case .strong:
                return .orange
            case .major:
                return .red
            }
        }
        
        static var allCasesSorted: [Category] {
            [
                .major,
                .strong,
                .moderate,
                .minor
            ]
        }
    }
}

extension Earthquake: Decodable {
    enum CodingKeys: String, CodingKey {
        case properties
        case geometry
    }

    enum PropertiesCodingKeys: String, CodingKey, Encodable {
        case title
        case place
        case date = "time"
        case mag
        case urlString = "url"
    }

    enum GeometryCodingKeys: String, CodingKey {
        case coordinates
    }

    init(from decoder: Decoder) throws {
        id = UUID()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let properties = try container.nestedContainer(keyedBy: PropertiesCodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)

        title = try properties.decode(String.self, forKey: .title)
        place = try properties.decode(String.self, forKey: .place)
        let time_ms = try properties.decode(UInt64.self, forKey: .date)
        let time_s = time_ms / 1000
        guard let interval = TimeInterval(exactly: time_s) else {
            throw NSError(domain: "Earthquake",
                          code: 0,
                          userInfo: [
                            NSLocalizedDescriptionKey: "Could not decode date of earthquake with id:\(id)"
                          ])
        }
        date = Date(timeIntervalSince1970: interval)
        mag = try properties.decode(Float.self, forKey: .mag)
        urlString = try properties.decode(String.self, forKey: .urlString)
        let coordinates = try geometry.decode([Float].self, forKey: .coordinates)
        location = Coordinates(longitude: coordinates[0], latitude: coordinates[1], depth: coordinates[2])
    }
}

struct EarthquakesList: Decodable {
    let features: [Earthquake]

    enum CodingKeys: String, CodingKey {
        case features
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        features = try container.decode([Earthquake].self, forKey: .features)
    }
}
