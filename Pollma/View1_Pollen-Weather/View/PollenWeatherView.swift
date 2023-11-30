//
//  PollenWeatherView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - View PollenWeatherView
struct PollenWeatherView: View {
    
    @ObservedObject var weatherVM = WeatherViewViewModel()
    @ObservedObject var settingsVM: SettingsViewViewModel
    @State private var appReboot: Bool = true
    
    // BODY
    var body: some View {
        
        VStack {
            // Subview
            HeaderView(weatherVM: weatherVM)
            
            Divider()
            
            ScrollView {
                // Subview
                WeatherCardContent(weatherVM: weatherVM)
                    .background(CardView())
                
                // Subview
                PollenCardContent(weatherVM: weatherVM, settingsVM: settingsVM)
                    .background(CardView())                
            }
        }
        .background(LightBackgroundView())
        .onAppear() {
            if appReboot {
                weatherVM.getPollenAndWeather(for: weatherVM.currentLocation.coordinate)
                appReboot.toggle()
            }
        }
    }
}


// MARK: - Preview
struct PollenWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        PollenWeatherView(settingsVM: SettingsViewViewModel())
    }
}
