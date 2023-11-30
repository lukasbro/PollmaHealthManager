//
//  MedizinItemView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview MedizinItemView
struct MedizinItemView: View {
    
    @ObservedObject var mediVM: MedicationViewViewModel
    @Environment(\.presentationMode) var presentationEdit
    @State var entity: MediEntity
    
    // BODY
    var body: some View {
        HStack {
            Image(systemName: "cross.case.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 45, maxHeight: 40)
            
            VStack (alignment: .leading){
                Text(entity.name ?? "Kein Name")
                    .bold()
                    .modifier(TruncatedLine())
                Text("\(entity.ration) " + (entity.einheit ?? "n.a."))
                    .modifier(TruncatedLine())
            }
            .customFontFootnote()
            .padding(.horizontal, 5)
            .padding(.vertical, 7)
            
            Spacer()
            
            ZStack {
                Circle()
                    .trim(from: 0.1, to: 1.0)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .frame(maxWidth: 40, maxHeight: 40)
                
                //Text(mediVM.getBestandPercentFor(entity: entity))
                    Text("90%")
                    .font(.caption2)
                    .fixedSize()
            }
            .padding(.trailing)
            
            Button {
                mediVM.isEditing.toggle()
                mediVM.showingSheet.toggle()
            } label: {
                // Shared View
                LinkButton(name: "pencil")
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $mediVM.showingSheet) {
                MedicationEditView(mediVM: mediVM)
            }
        }
        .padding().padding()
        .background(CardView())
    }
}
