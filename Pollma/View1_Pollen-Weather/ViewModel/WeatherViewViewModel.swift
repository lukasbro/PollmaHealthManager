//
//  WeatherViewViewModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation
import SwiftUI
import CoreLocation


// MARK: - ViewModel WeatherViewViewModel
final class WeatherViewViewModel: NSObject, ObservableObject {
    
    @Published var weather: WeatherResponse = emptyWeatherResponse()
    @Published var pollen: PollenResponse = emptyPollenResponse()
    @Published var cityFound: Array = ["Suche…", "Suche…"]
    @Published var currentLocation: CLLocation  = CLLocation(latitude: 50.0782, longitude: 8.2397)
    @Published var city: String = "Suche…" {
        didSet {
            getLocation()
        }
    }
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    // asynchronous execution of multiple network tasks
    private let dispatchGroup = DispatchGroup()
    
    
    // MARK: - initializing
    override init() {
        super.init()
        locationManager.delegate = self
        getCurrentLocation()
    }
    
    static func emptyWeatherResponse() -> WeatherResponse {
        // prevent collapsing views by initializing with an empty model
        // returns 23 empty instances of hourly Weather data and 8 different instances for 8 days
        return WeatherResponse(current: Weather(), hourly: [Weather](repeating: Weather(), count: 23), daily: [DailyWeather](repeating: DailyWeather(), count: 8))
    }
    
    static func emptyPollenResponse() -> PollenResponse {
        return PollenResponse(details: [DailyPollen](repeating: DailyPollen(), count: 3))
    }
    
    
    // MARK: - Weather Computed Properties
    var temperature: String {
        return getTempFor(temp: weather.current.temp)
    }
    
    var conditions: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].description
        }
        return ""
    }
    
    var windSpeed: String {
        return String(format: "%0.1f%m/s", weather.current.wind_speed)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather.current.humidity)
    }
    
    var rainChancesToday: Double {
        return weather.daily[0].pop ?? 0.0
    }
        
    var currentWeatherIcon: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return "sun.max.fill"
    }

    
    // MARK: - Weather / Pollen Helper Functions
    func getTempFor(temp: Double) -> String {
        return String(format: "%.0f", temp)
    }

    func getRainChancesFor(value: Double) -> String {
        let chances = value * 100
        return String(format: "%.0f%%", chances)
    }

    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func getDateFor(timestamp: Int) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func getDateBy(adding: Int) -> String {
        let getDay = Calendar.current.date(byAdding: .day, value: adding, to: Date())
        return dateFormatter.string(from: getDay!)
    }
    
    func getWeatherIconId(for weatherElement: DailyWeather) -> String {
        if weatherElement.weather.count > 0 {
            return weatherElement.weather[0].icon
        }
        return "sun.max.fill"
    }
    
    func getWeatherIconFor(id: String) -> Image {
        switch id {
        case "01d":
            return Image(systemName: "sun.max.fill")
        case "01n":
            return Image(systemName: "moon.fill")
        case "02d":
            return Image(systemName: "cloud.sun.fill")
        case "02n":
            return Image(systemName: "cloud.moon.fill")
        case "03d":
            return Image(systemName: "cloud.fill")
        case "03n":
            return Image(systemName: "cloud.fill")
        case "04d":
            return Image(systemName: "cloud.fill")
        case "04n":
            return Image(systemName: "cloud.fill")
        case "09d":
            return Image(systemName: "cloud.drizzle.fill")
        case "09n":
            return Image(systemName: "cloud.drizzle.fill")
        case "10d":
            return Image(systemName: "cloud.heavyrain.fill")
        case "10n":
            return Image(systemName: "cloud.heavyrain.fill")
        case "11d":
            return Image(systemName: "cloud.bolt.fill")
        case "11n":
            return Image(systemName: "cloud.bolt.fill")
        case "13d":
            return Image(systemName: "cloud.snow.fill")
        case "13n":
            return Image(systemName: "cloud.snow.fill")
        case "50d":
            return Image(systemName: "cloud.fog.fill")
        case "50n":
            return Image(systemName: "cloud.fog.fill")
        default:
            return Image(systemName: "sun.max.fill")
        }
    }

    func getAllergieLevelString(for allergie: String, onDay: Int) -> String {
        
        switch allergie {
        case "Ambrosia":
            return pollen.details[onDay].plants.ragweed?.pollenIndex.pollenDescription ?? "keine"
        case "Birke":
            return pollen.details[onDay].plants.birch?.pollenIndex.pollenDescription ?? "keine"
        case "Eiche":
            return pollen.details[onDay].plants.oak?.pollenIndex.pollenDescription ?? "keine"
        case "Erle":
            return pollen.details[onDay].plants.alder?.pollenIndex.pollenDescription ?? "keine"
        case "Esche":
            return pollen.details[onDay].plants.ash?.pollenIndex.pollenDescription ?? "keine"
        case "Gräser":
            return pollen.details[onDay].plants.graminales?.pollenIndex.pollenDescription ?? "keine"
        case "Hasel":
            return pollen.details[onDay].plants.hazel?.pollenIndex.pollenDescription ?? "keine"
        case "Kiefer":
            return pollen.details[onDay].plants.pine?.pollenIndex.pollenDescription ?? "keine"
        case "Olive":
            return pollen.details[onDay].plants.olive?.pollenIndex.pollenDescription ?? "keine"
        case "Pappel":
            return pollen.details[onDay].plants.cottonwood?.pollenIndex.pollenDescription ?? "keine"
        default:
            return "keine"
        }
    }
    
    func getAllergieLevelIcon(for allergie: String, onDay: Int) -> Image {
        
        var pollenIndexValue: Int
        
        switch allergie {
        case "Ambrosia":
            pollenIndexValue = pollen.details[onDay].plants.ragweed?.pollenIndex.pollenValue ?? 0
        case "Birke":
            pollenIndexValue = pollen.details[onDay].plants.birch?.pollenIndex.pollenValue ?? 0
        case "Eiche":
            pollenIndexValue = pollen.details[onDay].plants.oak?.pollenIndex.pollenValue ?? 0
        case "Erle":
            pollenIndexValue = pollen.details[onDay].plants.alder?.pollenIndex.pollenValue ?? 0
        case "Esche":
            pollenIndexValue = pollen.details[onDay].plants.ash?.pollenIndex.pollenValue ?? 0
        case "Gräser":
            pollenIndexValue = pollen.details[onDay].plants.graminales?.pollenIndex.pollenValue ?? 0
        case "Hasel":
            pollenIndexValue = pollen.details[onDay].plants.hazel?.pollenIndex.pollenValue ?? 0
        case "Kiefer":
            pollenIndexValue = pollen.details[onDay].plants.pine?.pollenIndex.pollenValue ?? 0
        case "Olive":
            pollenIndexValue = pollen.details[onDay].plants.olive?.pollenIndex.pollenValue ?? 0
        case "Pappel":
            pollenIndexValue = pollen.details[onDay].plants.cottonwood?.pollenIndex.pollenValue ?? 0
        default:
            pollenIndexValue = 0
        }
        
        switch pollenIndexValue {
        case 0:
            return Image(systemName: "face.dashed") // 􀥧
        case 1:
            return Image(systemName: "circle") // 􀀀
        case 2:
            return Image(systemName: "sleep") // 􀜚
        case 3:
            return Image(systemName: "circle.bottomhalf.fill") // 􀪖
        case 4:
            return Image(systemName: "circle.fill") // 􀀁
        case 5:
            return Image(systemName: "circle.dashed.inset.fill") // 􀧒
        default:
            return Image(systemName: "face.dashed") // 􀥧
        }
    }
    
    
    // MARK: - Formatters
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM."
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "de")
        formatter.dateFormat = "EE"
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    // MARK: - Network Call For Pollen and Weather Data
    func getPollenAndWeather(for coord: CLLocationCoordinate2D?) {
        
        if let coord = coord {
            let weatherURL = WeatherAPI.getURLFor(lat: coord.latitude, lon: coord.longitude)
            getJSONResponse(for: .weather, using: weatherURL)
            
            let pollenURL = PollenAPI.getURLFor(lat: coord.latitude, lon: coord.longitude)
            getJSONResponse(for: .pollen, using: pollenURL)
            
        } else {
            // default value: Wiesbaden
            let weatherURL = WeatherAPI.getURLFor(lat: 50.0782, lon: 8.2397)
            getJSONResponse(for: .weather, using: weatherURL)
            
            let pollenURL = PollenAPI.getURLFor(lat: 50.0782, lon: 8.2397)
            getJSONResponse(for: .pollen, using: pollenURL)
        }
    }
    
    private func getJSONResponse(for type: RequestType, using urlString: String) {
        
        switch type {
        case .weather:
            
            dispatchGroup.enter()
            
            // Defined in Folder "Networking"
            NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!) { (result) in
                
                switch result {
                case .success(let response):
                    // main thread, set published weather object to the response received
                    DispatchQueue.main.async {
                        self.weather = response
                        self.dispatchGroup.leave()
                    }
                case .failure(let err):
                    print(err)
                    self.dispatchGroup.leave()
                }
            }
        
        case .pollen:

            dispatchGroup.enter()
            
            NetworkManager<PollenResponse>.fetch(for: URL(string: urlString)!) { (result) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.pollen = response
                        self.dispatchGroup.leave()
                    }
                case .failure(let err):
                    print(err)
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private enum RequestType {
        case weather
        case pollen
    }

    
    // MARK: - Location Functions
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() {
        // string that user enters converted to coordinates by internal iOS API
        geoCoder.geocodeAddressString(city) { placemarks, error in
            if let places = placemarks, let place = places.first {
                let cityCountry = "\(place.name ?? "n.a."), \(place.country ?? "n.a.")"
                self.cityFound = cityCountry.components(separatedBy: ", ")
                // get data for the location
                self.getPollenAndWeather(for: place.location?.coordinate)
            }
        }
    }
    
    var localTimeforCity: String {
        let localTime = Date(timeIntervalSince1970: TimeInterval(weather.current.dt))
        let timeZone = TimeZone(identifier: weather.timezone)
        timeFormatter.timeZone = timeZone
        return timeFormatter.string(from: localTime)
    }
}

// MARK: - Location Delegate
extension WeatherViewViewModel: CLLocationManagerDelegate {
    
    //called when the user's location is updated
    public func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        self.currentLocation = currentLocation
        
        let location = CLLocation(latitude: currentLocation.coordinate.latitude,
                                  longitude: currentLocation.coordinate.longitude)
        
        // name of location by internal iOS API
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
            
            guard let place = placemarks?.first else {
                return
            }
            self.cityFound = ["\(place.locality ?? "Suche…")", "\(place.country ?? "Suche…")"]
        })
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error) {
        print("Attention: make sure a default location is selected in Xcode! --> \(error.localizedDescription)")
    }
}
