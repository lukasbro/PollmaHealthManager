//
//  WeatherDetailView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview WeatherDetailView
struct WeatherForecastView: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    
    // BODY
    var body: some View {
        
        VStack {
            Divider()
            
            ScrollView {
                VStack {
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
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    
                    ForEach(weatherVM.weather.daily) { weather in
                        dailyCell(weather: weather)
                    }
                }
                .padding()
                .background(
                    Color.white.opacity(0.4)
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                        .blur(radius: 0.5)
                        .padding(.horizontal))
            }
        }.background(LightBackgroundView())
    }
    
    var forecastHeader: some View {
        
    }
    
    private func dailyCell(weather: DailyWeather) -> some View {
        VStack {
            Divider().padding(.horizontal)
            
            HStack {
                VStack {
                    Text(weatherVM.getDayFor(timestamp: weather.dt).uppercased())
                        .customFontFootnote()
                    Text(weatherVM.getDateFor(timestamp: weather.dt))
                        .foregroundColor(.gray)
                        .customFontFootnote()
                }
                
                weatherVM.getWeatherIconFor(icon: weather.weather.count > 0 ? weather.weather[0].icon : "sun.max.fill")
                    .foregroundColor(CustomColor.primaryDark)
                    .font(.title3)
                    .padding(.leading, 24)
                
                Text("\(weatherVM.getRainChancesFor(value: weather.pop ?? 0.0))")
                    .customFontFootnote()
                    .frame(maxWidth:.infinity, alignment: .center)
                
                HStack {
                    Text("\(weatherVM.getTempFor(temp: weather.temp.max))º")
                        .customFontFootnote()
                    Text("/ \(weatherVM.getTempFor(temp: weather.temp.min))º")
                        .foregroundColor(.gray)
                        .customFontFootnote()
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}


// MARK: - Preview
struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weatherVM: WeatherViewViewModel())
    }
}
