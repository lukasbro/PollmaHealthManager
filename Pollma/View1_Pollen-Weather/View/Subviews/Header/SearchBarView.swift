//
//  SearchBarView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview SearchBarView
struct SearchBarView: View {
    
    @ObservedObject var weatherVM: WeatherViewViewModel
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    // BODY
    var body: some View {
        
        Group {
            TextField("", text: $searchText, onEditingChanged: { isEditing in
                self.isSearching = isEditing
            }, onCommit: {
                weatherVM.city = searchText
            })
            .customFontBody()
            .multilineTextAlignment(isSearching ? .leading : .center)
            .foregroundColor(isSearching ? .black : .gray)
            .padding(.horizontal, 40.0)
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 50)
                    .fill(CustomColor.secondaryLight)
            }
            .padding()
        )
        .overlay(
            // Local Subview
            glassClearQuitOverlay
        )
    }
    
    
    // MARK: - Glass / Clear / Quit Overlay View
    private var glassClearQuitOverlay: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            if isSearching {
                Button {
                    if searchText.isEmpty {
                        hideKeyboard()
                    } else {
                        searchText = ""
                    }
                } label: {
                    if searchText.isEmpty {
                        // Shared View
                        XMarkCircle()
                            .foregroundColor(.red)
                    } else {
                        // Shared View
                        XMarkCircle()
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 32)
    }
}


// MARK: - Preview
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(weatherVM: WeatherViewViewModel())
            //.preferredColorScheme(.dark)
    }
}
