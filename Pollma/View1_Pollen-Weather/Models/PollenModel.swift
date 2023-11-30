//
//  PollenModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation


// MARK: - PollenResponse
struct PollenResponse: Codable {
    let details: [DailyPollen]

    enum CodingKeys: String, CodingKey {
        case details = "data"
    }
}


// MARK: - DailyPollen
struct DailyPollen: Codable, Identifiable {
    let dt: String
    let overview: Overview
    let plants: Plants

    enum CodingKeys: String, CodingKey {
        case dt = "date"
        case overview = "types"
        case plants
    }

    init() {
        self.dt = ""
        self.overview = Overview()
        self.plants = Plants()
    }
}

extension DailyPollen {
    var id: UUID {
        return UUID()
    }
}


// MARK: - Overview
struct Overview: Codable, Identifiable {
    let grass, tree, weed: PollenDetail?

    init() {
        grass = PollenDetail()
        tree = PollenDetail()
        weed = PollenDetail()
    }
}

extension Overview {
    var id: UUID {
        return UUID()
    }
}


// MARK: - Plants
struct Plants: Codable, Identifiable {
    let graminales, hazel, oak, alder: PollenDetail?
    let pine, cottonwood, ragweed, birch: PollenDetail?
    let olive, ash: PollenDetail?

    init() {
        graminales = PollenDetail()
        hazel = PollenDetail()
        oak = PollenDetail()
        alder = PollenDetail()
        pine = PollenDetail()
        cottonwood = PollenDetail()
        ragweed = PollenDetail()
        birch = PollenDetail()
        olive = PollenDetail()
        ash = PollenDetail()
    }
}

extension Plants {
    var id: UUID {
        return UUID()
    }
}


// MARK: - PollenDetail
struct PollenDetail: Codable, Identifiable {
    let display_name: String
    let in_season, data_available: Bool
    let pollenIndex: PollenIndex

    enum CodingKeys: String, CodingKey {
        case pollenIndex = "index"
        case display_name
        case in_season
        case data_available
    }

    init() {
        display_name = ""
        in_season = false
        data_available = false
        pollenIndex = PollenIndex()
    }
}

extension PollenDetail {
    var id: UUID {
        return UUID()
    }
}


// MARK: - PollenIndex
struct PollenIndex: Codable, Identifiable{
    let pollenValue: Int?
    let pollenDescription: String?
    let pollenColor: String?

    enum CodingKeys: String, CodingKey {
        case pollenValue = "value"
        case pollenDescription = "category"
        case pollenColor = "color"
    }
    
    init(){
        pollenValue = 0
        pollenDescription = ""
        pollenColor = ""
    }
}

extension PollenIndex {
    var id: UUID {
        return UUID()
    }
}
