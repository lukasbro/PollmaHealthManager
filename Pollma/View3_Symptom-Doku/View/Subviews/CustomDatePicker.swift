//
//  CustomDatePicker.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview CustomDatePicker
struct CustomDatePicker: View {
    
    @ObservedObject var dokuVM: DokuViewViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    // BODY
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                // Button left
                Button {
                    dokuVM.setDate(to: -1)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .padding(10)
                }
                
                // Picker
                DatePicker("Datum", selection: $dokuVM.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .id(dokuVM.selectedDate)
                    .accentColor(CustomColor.primaryDark)
                    .environment(\.locale, Locale.init(identifier: "de"))
                    
                // Button right
                Button {
                    dokuVM.setDate(to: 1)
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .padding(10)
                }
                
                Spacer()
            }
            .padding(.top, 10)
            
            Divider().frame(maxWidth: 100)
        }
    }
}


// MARK: - Preview
struct CustomDatePicker_Previews: PreviewProvider {
        
    static var previews: some View {
        CustomDatePicker(dokuVM: DokuViewViewModel())
    }
}
