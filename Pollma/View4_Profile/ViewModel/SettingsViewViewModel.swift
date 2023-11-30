//
//  SettingsViewViewModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation
import CoreData

// MARK: - ViewModel SettingsViewViewModel
final class SettingsViewViewModel: ObservableObject {
    
    @Published var allergien: [AllergieItem] = []
    @Published var savedSettings: [UserDefaultEntity] = []
    private let settingsContainer: NSPersistentContainer
    
    
    // MARK: - initializing
    init() {
        settingsContainer = NSPersistentContainer(name: "UserDefaultModel")
        settingsContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("ERROR loading settings \(error), \(error.userInfo)")
            }
        }
        fetchSettings()
    }
    
    
    // MARK: - User Name
    func setDefaultUserName() {
        UserDefaults.standard.set("User", forKey: "username")
    }
    
    
    // MARK: - Fetch, edit, create, save, delete Allergie settings
    private func fetchSettings() {
        
        let request = NSFetchRequest<UserDefaultEntity>(entityName: "UserDefaultEntity")
        do {
            savedSettings = try settingsContainer.viewContext.fetch(request)
            if savedSettings.isEmpty {
                createDefaultSettings()
            }
            allergien = setAllergien()
        } catch let error {
            print("ERROR fetching settings \(error)")
        }
    }
    
    private func createDefaultSettings() {
        let defaultSetting = UserDefaultEntity(context: settingsContainer.viewContext)
        defaultSetting.ambrosia = true
        defaultSetting.birke = true
        defaultSetting.eiche = false
        defaultSetting.erle = false
        defaultSetting.esche = false
        defaultSetting.graeser = true
        defaultSetting.hasel = false
        defaultSetting.kiefer = false
        defaultSetting.olive = false
        defaultSetting.pappel = false
        saveData()
    }
    
    func editSettings() {
        savedSettings.first?.ambrosia = allergien[0].checked
        savedSettings.first?.birke = allergien[1].checked
        savedSettings.first?.eiche = allergien[2].checked
        savedSettings.first?.erle = allergien[3].checked
        savedSettings.first?.esche = allergien[4].checked
        savedSettings.first?.graeser = allergien[5].checked
        savedSettings.first?.hasel = allergien[6].checked
        savedSettings.first?.kiefer = allergien[7].checked
        savedSettings.first?.olive = allergien[8].checked
        savedSettings.first?.pappel = allergien[9].checked
        saveData()
    }
    
    private func setAllergien() -> [AllergieItem] {
        
        var allergieItems = [AllergieItem]()
        allergieItems.append(AllergieItem(label: "Ambrosia", checked: savedSettings.first?.ambrosia.self ?? false))
        allergieItems.append(AllergieItem(label: "Birke", checked: savedSettings.first?.birke.self ?? false))
        allergieItems.append(AllergieItem(label: "Eiche", checked: savedSettings.first?.eiche.self ?? false))
        allergieItems.append(AllergieItem(label: "Erle", checked: savedSettings.first?.erle.self ?? false))
        allergieItems.append(AllergieItem(label: "Esche", checked: savedSettings.first?.esche.self ?? false))
        allergieItems.append(AllergieItem(label: "Gräser", checked: savedSettings.first?.graeser.self ?? false))
        allergieItems.append(AllergieItem(label: "Hasel", checked: savedSettings.first?.hasel.self ?? false))
        allergieItems.append(AllergieItem(label: "Kiefer", checked: savedSettings.first?.kiefer.self ?? false))
        allergieItems.append(AllergieItem(label: "Olive", checked: savedSettings.first?.olive.self ?? false))
        allergieItems.append(AllergieItem(label: "Pappel", checked: savedSettings.first?.pappel.self ?? false))
            
        return allergieItems
    }

    private func saveData() {
        do {
            try settingsContainer.viewContext.save()
            fetchSettings()
        } catch let error {
            print("ERROR saving settings \(error)")
        }
    }

    // MARK: - For Debugging only
    private func deleteAllEntries() {
        let request = NSFetchRequest<UserDefaultEntity>(entityName: "UserDefaultEntity")
        
        do {
            savedSettings = try settingsContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching settings \(error)")
        }
        
        savedSettings.forEach { entity in
            settingsContainer.viewContext.delete(entity)
        }
        saveData()
    }
}
