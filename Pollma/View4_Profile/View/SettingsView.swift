//
//  SettingsView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - View SettingsView
struct SettingsView: View {
    
    @ObservedObject var settingsVM: SettingsViewViewModel
    @AppStorage("username") private var username = ""
    @State private var isEditing = false
    
    // BODY
    var body: some View {
        
        VStack(alignment: .leading) {
            // Local Subview
            settingsHeader
            
            // Local Subview
            settingsForm
        }
        // Shared View
        .background(LightBackgroundView())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    // MARK: - Settings Header
    private var settingsHeader: some View {
        
        Group {
            HStack (alignment: .bottom) {
                Text("Einstellungen.")
                    .customFontTitle()
                    .padding([.horizontal, .top])
                
                Spacer()
                
                Button (action: {
                    if isEditing {
                        hideKeyboard()
                        settingsVM.editSettings()
                    }
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .bold()
                        .customFontBody()
                        .foregroundColor(CustomColor.primaryDark)
                }.padding(.trailing, 25)
            }
            Divider()
        }
    }
    
    
    // MARK: - Settings Form
    private var settingsForm: some View {
        
        Form {
            Section(header: Text("DEIN NAME").customFontFootnote()) {
                TextField("Name", text: $username, onEditingChanged: { isEditing in
                    if !isEditing {
                        if username == "" {
                            settingsVM.setDefaultUserName()
                        }
                    }
                })
                .customFontBody()
            }
            .allowsHitTesting(isEditing)
            
            Section(header: Text("DEINE ALLERGIEN").customFontFootnote()) {
                List(settingsVM.allergien.indices) { index in
                    Toggle(settingsVM.allergien[index].label, isOn: $settingsVM.allergien[index].checked)
                        .toggleStyle(SwitchToggleStyle(tint: CustomColor.secondary))
                        .customFontBody()
                }
            }
            .allowsHitTesting(isEditing)
        }
        .accentColor(CustomColor.secondary)
        .onTapGesture {
            hideKeyboard()
        }
    }
}


// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsVM: SettingsViewViewModel())
    }
}
