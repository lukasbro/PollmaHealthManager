//
//  MedicationViewViewModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation
import SwiftUI
import CoreData

// MARK: - ViewModel MedicationViewViewModel
final class MedicationViewViewModel: ObservableObject {
    
    @Published var savedMedis: [MediEntity] = []
    @Published var mediName = ""
    @Published var mediEinheit = ""
    @Published var mediRation = ""
    @Published var mediBestand = ""
    @Published var mediRestbestand = "" {
        didSet {
            if ((Int(mediRestbestand) ?? 0) < 0) {
                mediRestbestand = "0"
            }
        }
    }
    @Published var mediZeitpunkt = Date()
    @Published var isEditing: Bool = false {
        didSet {
            if isEditing {
                mediName = savedMedis.last?.name ?? "Supertropfen"
                mediEinheit = savedMedis.last?.einheit ?? "ml"
                mediRation = String(Int(savedMedis.last?.ration ?? 1))
                mediBestand = String(Int(savedMedis.last?.bestand ?? 0))
                mediRestbestand = String(Int(savedMedis.last?.restbestand ?? 0))
                mediZeitpunkt = savedMedis.last?.zeitpunkt ?? Date()
            }
        }
    }
    @Published var showingSheet: Bool = false {
        didSet {
            if !showingSheet {
                resetAfterLeaving()
                if isEditing {
                    isEditing = false
                }
            }
        }
    }
    private let mediContainer: NSPersistentContainer
    
    
    // MARK: - initializing
    init() {
        mediContainer = NSPersistentContainer(name: "MediModel")
        mediContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("ERROR loading medis \(error), \(error.userInfo)")
            }
        }
        fetchEntry()
    }
    
    
    // MARK: - Helper Functions
    func getTimeFor(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func resetAfterLeaving() {
        mediName = ""
        mediEinheit = ""
        mediRation = ""
        mediBestand = ""
        mediRestbestand = ""
        mediZeitpunkt = Date()
    }
    
    
    // MARK: - Fetch, edit, create, save, delete Entries
    func fetchEntry() {
        let request = NSFetchRequest<MediEntity>(entityName: "MediEntity")
        do {
            savedMedis = try mediContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching medis \(error)")
        }
    }
    
    func getBestandFloatFor(entity: MediEntity) -> CGFloat {
        let floatValue = (CGFloat(entity.restbestand) / CGFloat(entity.bestand))
        
        if (floatValue == 0) {
            return 0.98
        } else {
            return (floatValue - 1) * -1
        }
    }
    
    func getBestandPercentFor(entity: MediEntity) -> String {
        let percentValue = ((Double(entity.restbestand) / Double(entity.bestand)) * 100)
        return String(format: "%.0f%%", percentValue)
    }

    func setMediBestand(isChecked: Bool, forId: UUID) {
        editMediWith(id: forId)
        
        if isChecked {
            savedMedis.last?.restbestand = (Int16(mediRestbestand) ?? 0) - Int16(savedMedis.last?.ration ?? 0)
        } else {
            savedMedis.last?.restbestand = (Int16(mediRestbestand) ?? 0) + Int16(savedMedis.last?.ration ?? 0)
        }
        saveData()
    }
    
    func editMediWith(id: UUID) {
        let request = NSFetchRequest<MediEntity>(entityName: "MediEntity")
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            savedMedis = try mediContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching medi \(error)")
        }
    }
    
    func addOrEditEntry() {
        if isEditing {
            savedMedis.last?.name = mediName
            savedMedis.last?.bestand = Int16(mediRestbestand) ?? 0
            savedMedis.last?.einheit = mediEinheit
            savedMedis.last?.ration = Int16(mediRation) ?? 0
            savedMedis.last?.restbestand = Int16(mediRestbestand) ?? 0
            savedMedis.last?.zeitpunkt = mediZeitpunkt
            isEditing = false
        } else {
            let newMedi = MediEntity(context: mediContainer.viewContext)
            
            if mediName != "" {
                newMedi.name = mediName
            } else {
                newMedi.name = "Kein Name"
            }
            
            if Int(mediRestbestand) ?? 0 < 0 {
                newMedi.bestand = 0
                newMedi.restbestand = 0
            } else {
                newMedi.bestand = Int16(mediRestbestand) ?? 0
                newMedi.restbestand = Int16(mediRestbestand) ?? 0
            }
            
            if mediEinheit != "" {
                newMedi.einheit = mediEinheit
            } else {
                newMedi.einheit = "ml"
            }
            newMedi.checked = false
            newMedi.ration = Int16(mediRation) ?? 0
            newMedi.zeitpunkt = mediZeitpunkt
            newMedi.id = UUID()
        }
        saveData()
    }
    
    func deleteEntry() {
        if !savedMedis.isEmpty {
            let entity = savedMedis[0]
            mediContainer.viewContext.delete(entity)
            saveData()
        }
        if isEditing {
            isEditing = false
        }
    }
    
    func saveData() {
        do {
            try mediContainer.viewContext.save()
            fetchEntry()
        } catch let error {
            print("ERROR saving Medidata \(error)")
        }
    }
    
    
    // MARK: - For Debugging only
    func deleteAllEntries() {
        let request = NSFetchRequest<MediEntity>(entityName: "MediEntity")
        
        do {
            savedMedis = try mediContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching Entry \(error)")
        }
        
        savedMedis.forEach { entity in
            mediContainer.viewContext.delete(entity)
        }
        saveData()
    }
}
