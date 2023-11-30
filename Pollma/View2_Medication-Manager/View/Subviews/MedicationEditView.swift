//
//  MedicationEditView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview MedicationEditView
struct MedicationEditView: View {
    
    @ObservedObject var mediVM: MedicationViewViewModel
    @Environment(\.presentationMode) var presentation
    @State private var showingDeleteAlert = false
    
    // BODY
    var body: some View {
        VStack (alignment: .leading) {
            HStack (alignment: .bottom) {
                Text("Medikament")
                    .customFontTitle()
                
                Spacer()
                
                Button {
                    hideKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .font(.title2)
                        .foregroundColor(CustomColor.primaryDark)
                }
            }
            
            Divider()
            
                HStack {
                    
                    createCell(name: "cross.case.fill", content: "Name:")
                    
                    TextField("Supertropfen", text: $mediVM.mediName)
                        .modifier(MediEditModifier())
                    
                }
                .padding(.top)
                .padding(.bottom, 5)
                
                
                
                HStack {
                    createCell(name: "number.circle.fill", content: "Ration: ")

                    TextField("1", text: $mediVM.mediRation)
                        .modifier(MediEditModifier())
                }
                .padding(.bottom, 5)
                
                HStack {
                    createCell(name: "pills.fill", content: "Einheit: ")

                    TextField("ml", text: $mediVM.mediEinheit)
                        .modifier(MediEditModifier())
                }
                .padding(.bottom, 5)
                
                HStack {
                    createCell(name: "scalemass.fill", content: "Bestand: ")

                    TextField("15", text: $mediVM.mediRestbestand)
                        .modifier(MediEditModifier())
                    
                }
                .padding(.bottom, 5)
                
                HStack {
                    Image(systemName: "timer")
                        .font(.title)
                        .foregroundColor(CustomColor.primary)
                        .padding(.trailing)
                    DatePicker("Einnahme", selection: $mediVM.mediZeitpunkt, displayedComponents: .hourAndMinute)
                        .customFontBody()
                }
                .padding(.bottom, 20)

            Spacer()
            
            HStack {
                if mediVM.isEditing {
                    Button {
                        showingDeleteAlert.toggle()
                    } label: {
                        CustomButton(content: "Löschen",
                                     icon: "xmark.bin.fill", backgroundColor: Color.red.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("Eintrag löschen?"),
                            message: Text("Aktion kann nicht rückgängig gemacht werden."),
                            primaryButton: .destructive(Text("Löschen")) {
                                mediVM.deleteEntry()
                                presentation.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                Button {
                    mediVM.addOrEditEntry()
                    presentation.wrappedValue.dismiss()
                } label: {
                    CustomButton(content: "Speichern",
                                           icon: "checkmark.circle.fill")
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding()
    }
    
    private func createCell(name: String, content: String) -> some View {
        Group {
            Image(systemName: name)
                .font(.title)
                .foregroundColor(CustomColor.primary)
                .padding(.trailing, 9)
            
            Text(content)
                .customFontBody()
        }
    }
}

struct MedicationEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationEditView(mediVM: MedicationViewViewModel())
        //            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
