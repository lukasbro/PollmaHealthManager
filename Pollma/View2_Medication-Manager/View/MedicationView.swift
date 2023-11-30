//
//  MedicationView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI
import CoreData

// MARK: - View MedicationView
struct MedicationView: View {
    
    @ObservedObject var mediVM = MedicationViewViewModel()
    @State private var pickerSelectedItem = 0
    @State private var selectedDate = Date()
    @State private var showingSheet = false
    
    // BODY
    var body: some View {
        
        VStack {
            // Local Subview
            mediHeader
            
            ScrollView {
                switch pickerSelectedItem {
                case 0:
                    if mediVM.savedMedis.isEmpty {
                        Text("Unter 'Medikamente' hinzufügen")
                            .foregroundColor(.gray)
                            .customFontBody()
                            .padding(.top, 100)
                    } else {
                        ForEach(mediVM.savedMedis) { entity in
                            // Subview
                            MediEinnahmeView(mediVM: mediVM, entity: entity)
                        }
                    }
                case 1:
                    VStack {
                        if mediVM.savedMedis.isEmpty {
                            // Shaerd View
                            AddEntryView()
                        } else {
                            ForEach(mediVM.savedMedis) { entity in
                                // Subview
                                MedizinItemView(mediVM: mediVM, entity: entity)
                            }
                        }
                    }
                default:
                    Text("not available")
                }
            }
            .padding(.horizontal)
        }
        .background(LightBackgroundView())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    // MARK: - Header
    private var mediHeader: some View {
        Group {
            HStack {
                Text("Medikamente.")
                    .customFontTitle()
                
                Spacer()
                
                if pickerSelectedItem == 1 {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .customFontTitle()
                            .foregroundColor(CustomColor.primaryDark)
                    }
                }
            }
            .padding([.horizontal, .top])
            
            Picker("Segmented Control", selection: $pickerSelectedItem) {
                Text("Einnahme").tag(0)
                Text("Medikamente").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 5)
            
            Divider()
        }
        .sheet(isPresented: $showingSheet) {
            // Subview
            MedicationEditView(mediVM: mediVM)
        }
    }
}


struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
    }
}
