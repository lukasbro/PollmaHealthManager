//
//  BackgroundViews.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - LightBackgroundView
struct LightBackgroundView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient:
                                Gradient(colors: [.white,
                                                  .white.opacity(0.0)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                
    //            LinearGradient(gradient:
    //                            Gradient(colors: [CustomColor.primaryLight.opacity(0.4),
    //                                              CustomColor.primaryDark.opacity(0.6)]),
    //                           startPoint: .topLeading,
    //                           endPoint: .bottomTrailing)
    //
    //            LinearGradient(gradient:
    //                            Gradient(colors: [CustomColor.primaryLight.opacity(0.9),
    //                                              CustomColor.primaryDark.opacity(0.9)]),
    //                           startPoint: .topLeading,
    //                           endPoint: .bottomTrailing)
                
                LinearGradient(gradient:
                                Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0.9),
                                                  CustomColor.primaryDark.opacity(0.4)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            }
            .ignoresSafeArea(.all)
        } else {
            LinearGradient(gradient:
                            Gradient(colors: [Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                                              Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
        }
    }
}


// MARK: - DarkBackgroundView
struct DarkBackgroundView: View {
    
    var body: some View {
        LinearGradient(gradient:
                        Gradient(colors: [CustomColor.primaryLight.opacity(0.99),
                                          CustomColor.primaryDark.opacity(0.95)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
    }
}


// MARK: - Preview
struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        DarkBackgroundView()
        LightBackgroundView()//.preferredColorScheme(.dark)
    }
}
