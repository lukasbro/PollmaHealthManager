//
//  NavLinkButton.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - LinkButton
struct LinkButton: View {
    
    @State var name = "chevron.right"
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
    
        Image(systemName: name)
            .font(.body)
            .foregroundColor(.black)
            .padding(10)
            .background(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)).opacity(0.5))
            .mask(Circle())
            .overlay(Circle().stroke(lineWidth: 0.1).fill(Color.white))
            .shadow(color: colorScheme == .light ? .black.opacity(0.3) : .black.opacity(0.8), radius: 10, x: 2, y: 2)
            .shadow(color: colorScheme == .light ? .white.opacity(0.8) : .white.opacity(0.3), radius: 10, x: -2, y: -2)
    }
}

struct NavLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        LinkButton()
    }
}
