//
//  PollenCardContent.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview PollenCardContent
struct PollenCardContent: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    @ObservedObject var settingsVM: SettingsViewViewModel
    
    // BODY
    var body: some View {
        
        VStack {
            // Local Subview
            pollenCardHeader
            
            ForEach(settingsVM.allergien) { allergie in
                if allergie.checked.self {
                    // Local Subview
                    createAllergieCell(with: allergie)
                }
            }
        }
        .padding()
        .padding(.bottom)
    }
    
    
    // MARK: - Pollen Card Header
    private var pollenCardHeader: some View {
        
        Group {
            HStack {
                VStack(alignment:.leading) {
                    Text("Pollenbelastung")
                        .bold()
                        .customFontBody()
                }
                
                Spacer()
                
                
                NavigationLink(
                    // Subview
                    destination: PollenForecastView(weatherVM: weatherVM,
                                                  settingsVM: settingsVM)
                        .navigationBarTitle("Pollenvorhersage",
                                            displayMode: .inline),
                    label: {
                        // Shared View
                        LinkButton()
                    })
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 1)
            
            HStack {
                Text("Allergie")
                Spacer()
                Text("Status")
            }
            .customFontBody()
            .padding(.horizontal)
            .padding(.bottom, 1)
        }
    }
    
    
    // MARK: - Allergien Today Cell Views
    private func createAllergieCell(with allergie: AllergieItem) -> some View {
        
        VStack {
            Divider()
            
            HStack {
                Text(allergie.label)
                    
                
                Spacer()
                
                Text(weatherVM.getAllergieLevelString(for: allergie.label, onDay: 0).lowercased())
                    .italic()
                    .padding(.trailing, 5)
                
                weatherVM.getAllergieLevelIcon(for: allergie.label, onDay: 0)
                    .font(.body)
                    .padding(.trailing, 7)
            }
            .customFontFootnote()
            .padding(.bottom, 1)
        }
        .padding(.horizontal)
    }
}


// MARK: - Preview
struct PollenCardContent_Previews: PreviewProvider {
    static var previews: some View {
        PollenCardContent(weatherVM: WeatherViewViewModel(), settingsVM: SettingsViewViewModel())
    }
}
