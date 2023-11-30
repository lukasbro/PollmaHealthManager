//
//  PollenForecastView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview PollenForecastView
struct PollenForecastView: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    @ObservedObject var settingsVM: SettingsViewViewModel
    
    // BODY
    var body: some View {
        
        VStack {
            Divider()
            
            ScrollView {
                VStack {
                    // Local Subview
                    pollenForecastHeader
                    
                    ForEach(settingsVM.allergien) { allergie in
                        if allergie.checked.self {
                            // Local Subview
                            createAllergieCell(with: allergie)
                        }
                    }
                }
                .padding().padding()
                // Shared View
                .background(CardView())
            }
        }
        // Shared View
        .background(LightBackgroundView())
    }
    
    
    // MARK: - Pollen Forecast Header
    private var pollenForecastHeader: some View {
        HStack {
            Text("Allergie")
                .customFontBody()
            
            Spacer()
            
            Text("HEUTE")
                .modifier(ForecastHeaderText())
            Text(weatherVM.getDateBy(adding: 1))
                .modifier(ForecastHeaderText())
            Text(weatherVM.getDateBy(adding: 2))
                .modifier(ForecastHeaderText())
        }
        .padding(.bottom, 1)
    }
    
    
    // MARK: - Daily Pollen Forecast Views
    private func createAllergieCell(with allergie: AllergieItem) -> some View {
        VStack {
            Divider()
            
            HStack {
                Text(allergie.label)
                    .customFontFootnote()
                
                Spacer()
                
                weatherVM.getAllergieLevelIcon(for: allergie.label, onDay: 0)
                    .padding(.trailing, 34)
                weatherVM.getAllergieLevelIcon(for: allergie.label, onDay: 1)
                    .padding(.trailing, 35)
                weatherVM.getAllergieLevelIcon(for: allergie.label, onDay: 2)
                    .padding(.trailing, 28)
            }
            .padding(.bottom,1)
        }
    }
}


// MARK: - Preview
struct PollenDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PollenForecastView(weatherVM: WeatherViewViewModel(), settingsVM: SettingsViewViewModel())
    }
}
