//
//  FontModifier.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - FontModifier - Custom Font: Futura
struct FontModifier: ViewModifier {
    
    var textStyle   : Font.TextStyle
    var fontSize    : CGFloat
    let fontFamily  = "Futura"

    func body(content: Content) -> some View {
        content.font(.custom(fontFamily, size: fontSize, relativeTo: textStyle))
    }
}

extension View {
    func customFontTitle() -> some View {
        self.modifier(FontModifier(textStyle: .title, fontSize: 26))
    }
    
    func customFontSubHeadline() -> some View {
        self.modifier(FontModifier(textStyle: .subheadline, fontSize: 15))
    }
    
    func customFontBody() -> some View {
        self.modifier(FontModifier(textStyle: .body, fontSize: 17))
    }
    
    func customFontFootnote() -> some View {
        self.modifier(FontModifier(textStyle: .footnote, fontSize: 13.5))
    }
}
