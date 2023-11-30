//
//  XMarkCircle.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - xMark Circle View
struct XMarkCircle: View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .padding(.vertical)
    }
}

struct XMarkCircle_Previews: PreviewProvider {
    static var previews: some View {
        XMarkCircle()
    }
}
