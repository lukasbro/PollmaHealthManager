//
//  AddEntryView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Add Entry
struct AddEntryView: View {
    var body: some View {
        Text("Eintrag mit '+' hinzufügen")
            .foregroundColor(.gray)
            .customFontBody()
            .padding(.top, 100)
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
