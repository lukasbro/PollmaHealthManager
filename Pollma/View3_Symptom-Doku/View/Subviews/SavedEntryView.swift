//
//  SavedEntryView.swift
//  Pollma
//
//  Created by Lukas Bröning on 30.07.21.
//

import SwiftUI

// MARK: - Subview SavedEntryView
struct SavedEntryView: View {
    
    @ObservedObject var dokuVM: DokuViewViewModel
    
    // BODY
    var body: some View {
        
        VStack{
            if dokuVM.savedEntries.isEmpty {
                // Shared View
                AddEntryView()
            } else {
                VStack (alignment: .leading) {
                    // Local Subview
                    eintragHeaderView
                    
                    // Local Subview
                    befindenRatingView
                    
                    // Local Subview
                    symptomeRatingView
                    
                    // Local Subview
                    eintragNotizView
                }
                .padding(.vertical, 25)
                .background(CardView())
            }
        }
    }
    
    
    // MARK: - Header des Eintrags
    private var eintragHeaderView: some View {
    
        Group {
            HStack (alignment: .bottom) {
                HStack {
                    Text ("Eintrag")
                        .fontWeight(.bold)
                        .customFontBody()
                    
                    Text ("vom \(dokuVM.selectedDate, style: .date).")
                        .customFontSubHeadline()
                }
                .padding([.leading, .top])
                
                Spacer()
                
                Button {
                    dokuVM.isEditing.toggle()
                    dokuVM.showingSheet.toggle()
                } label: {
                    // Shared View
                    LinkButton(name: "pencil")
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    
    // MARK: - Rating Befinden
    private var befindenRatingView: some View {
        HStack {
            createEntryImage(name: "face.smiling.fill")
            
            Text("Befinden: ")
                .fontWeight(.bold)
                .customFontFootnote()
            
            ForEach(0...(dokuVM.savedRatingBefinden), id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(CustomColor.primary)
                    .customFontFootnote()
            }
        }
        .padding([.bottom, .top, .horizontal])
    }
    
    
    // MARK: - Rating Symptome
    private var symptomeRatingView: some View {
        HStack {
            createEntryImage(name: "circle.bottomhalf.fill")
            
            Text("Symptome: ")
                .fontWeight(.bold)
                .customFontFootnote()
            
            ForEach(0...(dokuVM.savedRatingSymptome), id: \.self) { _ in
                Image(systemName: "circle.dashed.inset.fill")
                    .foregroundColor(CustomColor.primary)
                    .customFontFootnote()
            }
        }
        .padding([.bottom, .horizontal])
    }
    
    
    // MARK: - Notiz Eintrag
    private var eintragNotizView: some View {
        HStack (alignment: .top) {
            createEntryImage(name: "note.text")
            
            Text(dokuVM.savedEntry)
                .customFontBody()
                .padding([.bottom, .trailing], 10)
            Spacer()
        }
        .padding([.bottom, .horizontal])
    }
    
    
    // MARK: - Icon Creator
    private func createEntryImage(name: String) -> some View {
        Image(systemName: name)
            .font(.title2)
            .foregroundColor(CustomColor.primary)
            .padding(.horizontal)
    }
}


// MARK: - Preview
struct SavedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        SavedEntryView(dokuVM: DokuViewViewModel())
    }
}
