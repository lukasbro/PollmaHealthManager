//
//  DokuViewViewModel.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation
import SwiftUI
import CoreData

// MARK: - ViewModel DokuViewViewModel
final class DokuViewViewModel: ObservableObject {
    
    @Published var savedEntries: [DokuEntity] = []
    @Published var savedDataForStats: [DokuEntity] = []
    @Published var textFieldText: String = ""
    @Published var ratingBefinden: Int = 0
    @Published var ratingSymptome: Int = 0
    @Published var selectedDate: Date = Date() {
        didSet {
            entryDate = Calendar.current.startOfDay(for: selectedDate)
            fetchEntry()
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
    @Published var isEditing: Bool = false {
        didSet {
            if isEditing {
                textFieldText = savedEntries.last?.entryText ?? "Keine Notiz"
                ratingBefinden = Int(savedEntries.last?.ratingBefinden ?? 0)
                ratingSymptome = Int(savedEntries.last?.ratingSymptome ?? 0)
            }
        }
    }
    private let dokuContainer: NSPersistentContainer
    private var entryDate: Date = Calendar.current.startOfDay(for: Date())
    
    
    // MARK: - initializing
    init() {
        dokuContainer = NSPersistentContainer(name: "DokuModel")
        dokuContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("ERROR loading Entry \(error), \(error.userInfo)")
            }
        }
        fetchEntry()
    }
    
    
    // MARK: - Computed Properties & Helper Functions
    var savedEntry: String {
        return (savedEntries.last?.entryText ?? "keine Notiz")
    }
    
    var savedRatingBefinden: Int {
        return (Int(savedEntries.last?.ratingBefinden ?? 0) - 1)
    }
    
    var savedRatingSymptome: Int {
        return (Int(savedEntries.last?.ratingSymptome ?? 0) - 1)
    }
    
    func setDate(to day: Int) {
        selectedDate = Calendar.current.date(byAdding: .day, value: day, to: selectedDate) ?? Date()
    }
    
    func getRatingBefindenToday() -> CGFloat {
        return CGFloat(savedEntries.last?.ratingBefinden ?? 5)
    }
    
    func getRatingSymptomeToday() -> CGFloat {
        return CGFloat(savedEntries.last?.ratingSymptome ?? 5)
    }
    
    private func resetAfterLeaving() {
        textFieldText = ""
        ratingBefinden = 0
        ratingSymptome = 0
    }
    
    
    // MARK: - Fetch, edit, create, save, delete Entries
    private func fetchEntry() {
        let request = NSFetchRequest<DokuEntity>(entityName: "DokuEntity")
        request.predicate = NSPredicate(format: "entryDate == %@", self.entryDate as NSDate)
        
        do {
            savedEntries = try dokuContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching Entry \(error)")
        }
    }
    
    func fetchDataForStats() {
        let startDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())
        let today = Date()
        
        let request = NSFetchRequest<DokuEntity>(entityName: "DokuEntity")
        request.predicate = NSPredicate(format: "entryDate >= %@ AND entryDate < %@", argumentArray: [startDate! as NSDate, today as NSDate])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DokuEntity.entryDate, ascending: true)]

        do {
            savedDataForStats = try dokuContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching Entry \(error)")
        }
    }
        
    func addOrEditEntry() {
        if isEditing {
            savedEntries.last?.entryText = textFieldText
            savedEntries.last?.ratingBefinden = Int16(ratingBefinden)
            savedEntries.last?.ratingSymptome = Int16(ratingSymptome)
            isEditing = false
        } else {
            let newEntry = DokuEntity(context: dokuContainer.viewContext)
            
            newEntry.entryDate = entryDate
            
            if textFieldText != "" {
                newEntry.entryText = textFieldText
            } else {
                newEntry.entryText = "Keine Notiz"
            }
            
            if ratingBefinden == 0 {
                newEntry.ratingBefinden = 1
            } else {
                newEntry.ratingBefinden = Int16(ratingBefinden)
            }
            
            if ratingSymptome == 0 {
                newEntry.ratingSymptome = 1
            } else {
                newEntry.ratingSymptome = Int16(ratingSymptome)
            }
        }
        saveData()
    }
    
    func deleteEntry() {
        if !savedEntries.isEmpty {
            let entity = savedEntries[0]
            dokuContainer.viewContext.delete(entity)
            saveData()
        }
        if isEditing {
            isEditing = false
        }
    }
    
    private func saveData() {
        do {
            try dokuContainer.viewContext.save()
            fetchEntry()
        } catch let error {
            print("ERROR saving Medidata \(error)")
        }
    }
    
    
    // MARK: - For Debugging only
    private func deleteAllEntries() {
        let request = NSFetchRequest<DokuEntity>(entityName: "DokuEntity")
        
        do {
            savedEntries = try dokuContainer.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching Entry \(error)")
        }
        
        savedEntries.forEach { entity in
            dokuContainer.viewContext.delete(entity)
        }
        saveData()
    }
}
