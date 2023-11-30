//
//  InfoSheetView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - Subview InfoSheetView
struct InfoSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // BODY
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                
                
                // Sheet Swipe-Balken
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
                    .frame(width: geometry.size.width / 3,
                           height: geometry.size.height / 150)
                    .padding()
                
                VStack (alignment: .leading) {
                    // Local Subview
                    headerTitleView
                    
                    // Local Subview
                    appInfoView
                    
                    // Local Subview
                    bpiLegendeView
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Dismiss Button
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    // Shared View
                    CustomButton(content: "Verstanden",
                                 icon: "checkmark.circle.fill",
                                 backgroundColor: Color(#colorLiteral(red: 0.06143707037, green: 0.4141866863, blue: 0.3850664496, alpha: 1)))
                }
                .padding()
                
            }
            .foregroundColor(.black)
            // Shared Views
            .background(DarkBackgroundView())
            .background(ClearBackground())
        }
    }
    
    
    // MARK: - Header und Überschrift
    var headerTitleView: some View {
        
        Group {
            Text("Herzlich willkommen,")
            
            Text("\(UserDefaults.standard.string(forKey: "username") ?? "User").")
                .bold()
                .modifier(TruncatedLine())
            
            Divider()
                .padding(.horizontal)
            
            HStack (alignment: .bottom) {
                Text("Pollma.")
                
                Text("Die All-in-One-Lösung.")
                    .bold()
                    .customFontFootnote()
                    .padding(.bottom, 3)
            }
            .padding(.top, 10)
            .padding(.bottom, 1)
        }
        .customFontTitle()
    }
    
    
    // MARK: - App-Informationen
    var appInfoView: some View {
        
        Group {
            Text("Pollma vereint die individualisierte Pollenflug- und Wettervorhersage mit Medikamenten-Management und Symptom-Dokumentation. Die bestmögliche Unterstützung für Pollenallergiker immer und überall.")
                .customFontBody()
            
            Text("Pollma nutzt den BreezoMeter Pollenindex (BPI), einen weltweit einheitlichen Index für die Pollenkonzetration in der Luft.")
                .customFontFootnote()
                .padding(.vertical, 5)
        }
        .frame(maxWidth: 500, alignment: .topLeading)
    }
    
    
    // MARK: - Legende BPI
    var bpiLegendeView: some View {
        
        Group {
            Text("Legende: ")
                .bold()
                .customFontFootnote()
                .frame(maxWidth: 500, alignment: .topLeading)
                .padding(.bottom,1)
            
            createLegendeStack(icon: "face.dashed", content: "keine")
            createLegendeStack(icon: "circle", content: "sehr niedrig")
            createLegendeStack(icon: "sleep", content: "niedrig")
            createLegendeStack(icon: "circle.bottomhalf.fill", content: "mittelhoch")
            createLegendeStack(icon: "circle.fill", content: "hoch")
            createLegendeStack(icon: "circle.dashed.inset.fill", content: "sehr hoch")
        }
    }
    
    private func createLegendeStack(icon: String, content: String) -> some View {
        
        HStack (alignment: .top) {
            Image(systemName: icon)
                .font(.title2)
                .padding([.bottom, .trailing], 5)
            
            Text(content)
                .italic()
                .customFontBody()
        }
    }
}


// MARK: - Preview
struct InfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        InfoSheetView()
            
    }
}
