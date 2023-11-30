//
//  CustomViewModifiers.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Shadow For Circle Buttons
struct RoundedButtonShapeShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask(Circle())
            .overlay(Circle()
                        .stroke(lineWidth: 0.5)
                        .fill(Color.white.opacity(0.3))
            )
            .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
    }
}

// MARK: - Text truncation / line limit
struct TruncatedLine: ViewModifier {
    func body(content: Content) -> some View {
        content
            .truncationMode(.tail)
            .lineLimit(1)
    }
}


// MARK: - Forecast Header Text
struct ForecastHeaderText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .customFontFootnote()
            .padding(.trailing, 14.8)
    }
}


// MARK: - Clear Background For Sheet Views
/** Credits to "BackgroundClearView" by "Asperi" from https://stackoverflow.com/questions/63745084/how-can-i-make-a-background-color-with-opacity-on-a-sheet-view */
struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let clearView = UIView()
        DispatchQueue.main.async {
            clearView.superview?.superview?.backgroundColor = .clear
        }
        return clearView
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - MediEditModifier
struct MediEditModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding(.leading, 3)
            .lineLimit(1)
            .customFontBody()
            .keyboardType(.numberPad)
            .padding(3)
            .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
            .cornerRadius(10)
    }
}
