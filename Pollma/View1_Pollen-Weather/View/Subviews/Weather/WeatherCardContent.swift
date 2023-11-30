//
//  WeatherCardContent.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview WeatherCardContent
struct WeatherCardContent: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var moveIcon: Bool = false
    
    // BODY
    var body: some View {
        
        VStack(alignment:.leading) {
            // Local Subview
            weatherCardHeader
            
            // Local Subview
            currentWeather
            
            // Local Subview
            currentWeatherDetail
        }
        .padding()
    }
    
    
    // MARK: - Weather Card Header
    private var weatherCardHeader: some View {
        Group {
            HStack {
                VStack(alignment:.leading) {
                    Text(weatherVM.cityFound[0])
                        .bold()
                        .modifier(TruncatedLine())
                        .customFontTitle()
                }
                
                Spacer()
                
                NavigationLink(
                    // Subview 
                    destination: WeatherForecastView(weatherVM: weatherVM)
                        .navigationBarTitle("Wettervorhersage",
                                            displayMode: .inline),
                    label: {
                        // Shared View
                        LinkButton()
                    })
                    .navigationBarHidden(true)
            }
            .padding([.top, .horizontal])
            
            Text(weatherVM.cityFound[1] + " um \(weatherVM.localTimeforCity)")
                .padding(.leading)
                .modifier(TruncatedLine())
                .customFontFootnote()
        }
    }
    
    
    // MARK: - Current Weather
    private var currentWeather: some View {
        VStack {
            weatherVM.getWeatherIconFor(id: weatherVM.currentWeatherIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(CustomColor.secondaryLight)
                .padding(2)
                .frame(maxWidth: .infinity, maxHeight: 120)
                .shadow(color: colorScheme == .light ? .black.opacity(0.2) : .black.opacity(0.5), radius: 10, x: 5, y: 5)
                .shadow(color: colorScheme == .light ? .white.opacity(0.7) : .white.opacity(0.2), radius: 10, x: -5, y: -5)
                .animation(Animation.interpolatingSpring(mass: 1, stiffness: 200, damping: 5, initialVelocity: 4))
                .onAppear(){
                    moveIcon.toggle()
                }
            
            VStack(alignment: .center) {
                Text("\(weatherVM.conditions)")
                    .customFontFootnote()
                    .padding(.vertical, 3)
                
                Text("\(weatherVM.temperature)℃")
                    .bold()
                    .customFontTitle()
                    .padding(.vertical, 3)
            }
        }
    }
    
    
    // MARK: - Current Weather Detail
    private var currentWeatherDetail: some View {
        HStack {
            createCurrentWeatherDetail(image: "umbrella.fill", content: weatherVM.getRainChancesFor(value: weatherVM.rainChancesToday))
            Spacer()
            createCurrentWeatherDetail(image: "drop.fill", content: weatherVM.humidity)
            Spacer()
            createCurrentWeatherDetail(image: "wind", content: weatherVM.windSpeed)
        }
        .padding([.bottom, .horizontal])
        .padding(.horizontal)
    }
    
    private func createCurrentWeatherDetail(image: String, content: String) -> some View {
        
        HStack {
            Image(systemName: image)
                .font(.body)
                .foregroundColor(CustomColor.primaryDark)
            
            Text(content)
                .customFontFootnote()
        }
    }
}


// MARK: - Preview
struct WeatherCardContent_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCardContent(weatherVM: WeatherViewViewModel())
    }
}
