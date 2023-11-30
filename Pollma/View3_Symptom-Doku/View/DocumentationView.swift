//
//  DocumentationView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - View DocumentationView
struct DocumentationView: View {
    
    @ObservedObject var dokuVM = DokuViewViewModel()
    @State private var showingAlert = false
    
    // BODY
    var body: some View {
        
        VStack {
            // Local Subview
            dokumentationHeader
            
            // Shared View
            CustomDatePicker(dokuVM: dokuVM)
            
            ScrollView {
                // Subview
                SavedEntryView(dokuVM: dokuVM)
            }
        }
        // Shared View
        .background(LightBackgroundView())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    // MARK: - View Header
    private var dokumentationHeader: some View {
        Group {
            HStack {
                Text("Dokumentation.")
                    .customFontTitle()
                
                Spacer()
                
                
                // Statistiken
                NavigationLink(
                    // Subview
                    destination: StatisticsView(dokuVM: dokuVM)
                        .navigationBarTitle("Statistiken",
                                            displayMode: .inline),
                    label: {
                        Image(systemName: "chart.bar.xaxis")
                            .customFontTitle()
                            .foregroundColor(CustomColor.primaryDark)
                    })
                    .padding(.trailing, 25)
                
                
                // Eintrag hinzufügen
                Button (action: {
                    if dokuVM.savedEntries.isEmpty {
                        dokuVM.showingSheet.toggle()
                    } else {
                        showingAlert.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .customFontTitle()
                        .foregroundColor(CustomColor.primaryDark)
                }
                .sheet(isPresented: $dokuVM.showingSheet) {
                    // Subview
                    DokuEditView(dokuVM: dokuVM)
                }
                .alert(isPresented: $showingAlert) {
                    // Alert View
                    Alert(title: Text("Ups!"), message: Text("Du hast bereits einen Eintrag für dieses Datum hinzugefügt."), dismissButton: .default(Text("OK")))
                }
            }
            .padding([.horizontal, .top])
            
            Divider()
        }
    }
}


// MARK: - Preview
struct DocumentationView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentationView()
    }
}
