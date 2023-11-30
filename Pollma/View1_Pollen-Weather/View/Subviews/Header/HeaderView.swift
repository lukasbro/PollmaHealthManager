//
//  HeaderView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview HeaderView
struct HeaderView: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    @State private var searchText = "Suche Ort"
    @State private var isSearching = false
    @State private var showingSheet = false
    
    // BODY
    var body: some View {
        
        HStack {
            // Local Subview
            infoButtonView
            
            // Subview
            SearchBarView(weatherVM: weatherVM, searchText: $searchText, isSearching: $isSearching)
            
            // Local Subview
            searchButtonView
        }
    }
    
    
    // MARK: - Info Button
    private var infoButtonView: some View {
        
        Button {
            showingSheet.toggle()
        } label: {
            Image(systemName: "info.circle")
                .font(.title)
                .foregroundColor(CustomColor.secondaryDark)
                .background(Color.white)
                .modifier(RoundedButtonShapeShadow())
                .padding(.leading)
        }
        .sheet(isPresented: $showingSheet) {
            // Subview
            InfoSheetView()
        }
    }
    
    
    // MARK: - Search/Location Button
    private var searchButtonView: some View {
        
        Button {
            if isSearching {
                weatherVM.city = searchText
                hideKeyboard()
            } else {
                weatherVM.getCurrentLocation()
                weatherVM.getPollenAndWeather(for: weatherVM.currentLocation.coordinate)
            }
        } label: {
            Image(systemName: isSearching ? "magnifyingglass" : "location.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(CustomColor.secondaryDark)
                .modifier(RoundedButtonShapeShadow())
                .padding(.trailing)
        }
    }
}


// MARK: - Preview
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(weatherVM: WeatherViewViewModel())
    }
}
