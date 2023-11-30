//
//  WeatherModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation


// MARK: - WeatherResponse Object
struct WeatherResponse: Codable {
    let current: Weather
    let hourly: [Weather]
    let daily: [DailyWeather]
    var timezone: String = ""
}


// MARK: - Weather (Current / Hourly)
// identifiable for swiftui to recognize each record individually
struct Weather: Codable, Identifiable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [WeatherDetail]
    
    // empty case needed, intialialize with default values.
    init () {
        dt = 0
        temp = 0.0
        feels_like = 0.0
        pressure = 0
        humidity = 0
        dew_point = 0.0
        clouds = 0
        wind_speed = 0.0
        wind_deg = 0
        weather = []
    }
}

extension Weather {
    var id: UUID {
        return UUID()
    }
}


// MARK: - WeatherDetail
struct WeatherDetail: Codable {
    let main: String
    let description: String
    let icon: String
}


// MARK: - DailyWeather
struct DailyWeather: Codable, Identifiable {
    let dt, humidity: Int
    let temp: Temperature
    let weather: [WeatherDetail]
    let dew_point, wind_speed: Double
    let pop: Double?
    
    init() {
        dt = 0
        temp = Temperature(min: 0.0, max: 0.0)
        weather = [WeatherDetail(main: "", description: "", icon: "")]
        humidity = 0
        dew_point = 0.0
        wind_speed = 0.0
        pop = 0.0
    }
}

extension DailyWeather {
    var id: UUID {
        return UUID()
    }
}


// MARK: - Temperature
struct Temperature: Codable {
    let min: Double
    let max: Double
}
