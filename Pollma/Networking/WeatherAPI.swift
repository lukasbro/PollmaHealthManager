//
//  WeatherAPI.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation


struct WeatherAPI {
    static let key = "your_key"
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    static func getURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURL)onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(key)&units=metric&lang=de"
    }
}
