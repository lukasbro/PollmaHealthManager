//
//  DokuEditView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview DokuEditView
struct DokuEditView: View {
    
    @ObservedObject var dokuVM: DokuViewViewModel
    @Environment(\.presentationMode) private var presentation
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingAlert = false
    
    // BODY
    var body: some View {
        
        VStack (alignment: .leading) {
            
            // Local Subview
            editorHeader
            
            // Local Subview
            editorBefindenRating
            
            // Local Subview
            editorSymptomeRating
            
            // Local Subview
            customTextEditor
            
            Spacer()
            
            // Local Subview
            saveAndDeleteButtons
        }
        .padding()
    }
    
    
    // MARK: - Editor Header
    private var editorHeader: some View {
        
        Group {
            HStack (alignment: .bottom) {
                Text("Eintrag")
                    .customFontTitle()
                
                Text("vom \(dokuVM.selectedDate, style: .date)")
                    .customFontBody()
                    .padding(.bottom,2)
                
                Spacer()
                
                Button {
                    hideKeyboard()
                } label: {
                    KeyBoardDownIcon()
                }
            }
            
            Divider()
        }
    }
    
    
    // MARK: - Befinden Rating
    private var editorBefindenRating: some View {
        
        HStack {
            // Local Subview
            createImageForEditor(name: "face.smiling.fill")
            
            Text("Befinden: ")
                .customFontFootnote()
            
            // Subview
            RatingView(rating: $dokuVM.ratingBefinden, usesStarIcon: true)
        }
        .padding([.bottom, .top], 10)
    }
    
    
    // MARK: - Symptome Rating
    private var editorSymptomeRating: some View {
        
        HStack {
            // Local Subview
            createImageForEditor(name: "circle.bottomhalf.fill")

            Text("Symptome: ")
                .customFontFootnote()
            
            // Subview
            RatingView(rating: $dokuVM.ratingSymptome, usesStarIcon: false)
        }
        .padding(.bottom, 10)
    }
    
    
    // MARK: - Custom TextEditor
    private var customTextEditor: some View {
        
        HStack (alignment: .top) {
            // Local Subview
            createImageForEditor(name: "note.text")

            TextEditor(text: $dokuVM.textFieldText)
                .foregroundColor(.gray)
                .padding(5)
                .padding(.trailing, 30)
                .colorMultiply((colorScheme == .light) ? Color(#colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)) : Color.black.opacity(0.7))
                .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                .cornerRadius(10)
                .customFontBody()
                .overlay(
                    Button {
                        dokuVM.textFieldText = ""
                    } label: {
                        // Shared Subview
                        XMarkCircle()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing)
                )
        }
        .padding(.bottom, 1)
    }
    
    
    // MARK: - Save And Delete Buttons
    private var saveAndDeleteButtons: some View {
        
        HStack {
            if dokuVM.isEditing {
                Button {
                    showingAlert.toggle()
                } label: {
                    // Shared View
                    CustomButton(content: "Löschen",
                                 icon: "xmark.bin.fill", backgroundColor: Color.red.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .alert(isPresented: $showingAlert) {
                    // Alert View
                    Alert(
                        title: Text("Eintrag löschen?"),
                        message: Text("Aktion kann nicht rückgängig gemacht werden."),
                        primaryButton: .destructive(Text("Löschen")) {
                            dokuVM.deleteEntry()
                            presentation.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            Button {
                dokuVM.addOrEditEntry()
                presentation.wrappedValue.dismiss()
            } label: {
                CustomButton(content: "Speichern",
                                       icon: "checkmark.circle.fill")
            }
            .padding(.top)
        }
    }
    
    
    // MARK: - Icon Creator
    private func createImageForEditor(name: String) -> some View {
        Image(systemName: name)
            .font(.title)
            .foregroundColor(CustomColor.primary)
            .padding(.trailing)
    }
}


struct DokuEditView_Previews: PreviewProvider {
    static var previews: some View {
        DokuEditView(dokuVM: DokuViewViewModel())
    }
}
