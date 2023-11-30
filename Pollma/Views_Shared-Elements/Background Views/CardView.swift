//
//  CardView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Card Background View
struct CardView: View {
    
    var body: some View {
        
        Color.white.opacity(0.4)
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
            .blur(radius: 0.5)
            .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
