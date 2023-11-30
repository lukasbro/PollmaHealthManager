//
//  KeyBoardDownIcon.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - KeyBoardDownIcon
struct KeyBoardDownIcon: View {
    var body: some View {
        Image(systemName: "keyboard.chevron.compact.down")
            .font(.title2)
            .foregroundColor(CustomColor.primaryDark)
    }
}

struct KeyBoardDownIcon_Previews: PreviewProvider {
    static var previews: some View {
        KeyBoardDownIcon()
    }
}
