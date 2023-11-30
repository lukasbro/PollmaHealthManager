//
//  WeatherForecastView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview WeatherForecastView
struct WeatherForecastView: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    
    // BODY
    var body: some View {
        
        VStack {
            Divider()
            
            ScrollView {
                VStack {
                    // Local Subview
                    weatherForecastHeader
                    
                    ForEach(weatherVM.weather.daily) { weather in
                        // Local Subview
                        createDailyCellView(weather: weather)
                    }
                }
                .padding()
                .padding([.top, .bottom])
                // Shared View
                .background(CardView())
            }
        }
        // Shared View
        .background(LightBackgroundView())
    }
    
    
    // MARK: - Weather Forecast Header
    private var weatherForecastHeader: some View {
        
        HStack (alignment: .bottom){
            Text("Tag")
                .padding(.leading, 5)
            
            Image(systemName: "cloud.sun.fill")
                .font(.title3)
                .padding(.leading, 30)
            
            Image(systemName: "umbrella.fill")
                .font(.title3)
                .frame(maxWidth:.infinity, alignment: .center)
            
            Text("max")
                .customFontFootnote()
            
            Text("/ min")
                .foregroundColor(.gray)
                .customFontFootnote()
        }
        .customFontBody()
        .padding(.bottom, 5)
        .padding(.horizontal)
    }
    
    
    // MARK: - Daily Weather Cell Views
    private func createDailyCellView(weather: DailyWeather) -> some View {
        VStack {
            Divider().padding(.horizontal)
            
            HStack {
                VStack {
                    Text(weatherVM.getDayFor(timestamp: weather.dt).uppercased())
                    
                    Text(weatherVM.getDateFor(timestamp: weather.dt))
                        .foregroundColor(.gray)
                }
                
                weatherVM.getWeatherIconFor(id: weatherVM.getWeatherIconId(for: weather))
                    .foregroundColor(CustomColor.primaryDark)
                    .font(.title3)
                    .padding(.leading, 24)
                
                Text("\(weatherVM.getRainChancesFor(value: weather.pop ?? 0.0))")
                    .frame(maxWidth:.infinity, alignment: .center)
                
                HStack {
                    Text("\(weatherVM.getTempFor(temp: weather.temp.max))º")
                    Text("/ \(weatherVM.getTempFor(temp: weather.temp.min))º")
                        .foregroundColor(.gray)
                        
                }
            }
            .customFontFootnote()
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}


// MARK: - Preview
struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(weatherVM: WeatherViewViewModel())
    }
}
