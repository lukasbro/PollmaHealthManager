//
//  AllergieItemModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation

struct AllergieItem: Identifiable {
    let id = UUID()
    var label: String = ""
    var checked: Bool = false
}
