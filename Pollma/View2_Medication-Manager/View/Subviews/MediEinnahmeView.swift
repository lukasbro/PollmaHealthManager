//
//  MediEinnahmeView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview MediEinnahmeView
struct MediEinnahmeView: View {
    
    @ObservedObject var mediVM: MedicationViewViewModel
    @State var entity: MediEntity
    @State private var showingAlert = false
    @State private var mediEingenommen = false
    
    // BODY
    var body: some View {
        HStack{
            VStack (alignment: .leading) {
                HStack {
                    Text((mediVM.getTimeFor(date: entity.zeitpunkt ?? Date())) + " Uhr")
                        .customFontBody()
                    
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title3)
                    }
                }
                .padding(.bottom, 1)
                
                HStack {
                    Image(systemName: "pills")
                    
                    Text(entity.name ?? "Supertropfen")
                    
                    Image(systemName: mediEingenommen ? "checkmark.shield.fill" : "exclamationmark.arrow.circlepath")
                        .padding(.leading)
                    
                    Text(mediEingenommen ? "eingenommen" : "ausstehend")
                }
                .customFontFootnote()
            }
            
            Spacer()
            
            VStack {
                Button {
                    showingAlert.toggle()
                    mediEingenommen.toggle()
                    //entity.checked.toggle()
                    //mediVM.setMediBestand(isChecked: entity.checked, forId: entity.id ?? UUID())
                } label: {
                    Image(systemName: mediEingenommen ? "checkmark.circle.fill" : "checkmark.circle")
                        .customFontTitle()
                }
            }
        }
        .padding().padding()
        .background(CardView())
        .alert(isPresented: $showingAlert) {
            // Alert View
            Alert(title: Text("Baustelle"), message: Text("Hier sind noch nicht alle Funktionen umgesetzt."), dismissButton: .default(Text("OK")))
        }
    }
}
