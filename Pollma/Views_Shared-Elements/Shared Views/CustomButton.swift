//
//  CustomButton.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Custom Button Label Appearance
struct CustomButton: View {
    @State var content: String
    @State var icon: String
    @State var backgroundColor: Color = CustomColor.primary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .padding(.trailing, 1)
            Text(content)
        }
        .foregroundColor(CustomColor.secondaryLight)
        .padding(13)
        .background(backgroundColor)
        .mask(RoundedRectangle(cornerRadius: 15))
        .customFontBody()
        .frame(maxWidth: .infinity)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(content: "Speichern", icon: "checkmark.circle.fill")
    }
}
