//
//  PollenAPI.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation


struct PollenAPI {
    // key nur begrenzte Zeit aktiv!
    static let key = "your_key"
    static let baseURL = "https://api.breezometer.com/pollen/v2/forecast/"

    static func getURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURL)daily?lat=\(lat)&lon=\(lon)&key=\(key)&features=types_information,plants_information&days=3&lang=de"
    }
}
