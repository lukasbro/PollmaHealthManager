//
//  StatisticsView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview StatisticsView
struct StatisticsView: View {
    
    @ObservedObject var dokuVM: DokuViewViewModel
    @State private var pickerSelectedItem: Int = 0
    @State private var showingAlert: Bool = false
    @State private var moveIcon: Bool = false

    // BODY
    var body: some View {
        
        VStack {
            // Segmented Control
            Picker("Segmented Control", selection: $pickerSelectedItem) {
                Text("Befinden").tag(0)
                Text("Symptome").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            .onAppear{
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(CustomColor.primaryDark)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            }
            
            ScrollView {
                switch pickerSelectedItem {
                case 0:
                    // Local Subview
                    befindenStatistik
                case 1:
                    // Local Subview
                    symptomeStatistik
                default:
                    Text("not available")
                }
                
            }
        }
        .padding()
        .onAppear{
            showingAlert.toggle()
        }
        .alert(isPresented: $showingAlert) {
            // Alert View
            Alert(title: Text("Baustelle"), message: Text("Charts werden aktuell nur dann korrekt angezeigt, wenn für heute und die vorherigen 5 Tage vollstände Einträge vorhanden sind."), dismissButton: .default(Text("OK")))
        }
        // Shared View
        .background(LightBackgroundView())
        .onAppear{
            dokuVM.fetchDataForStats()
        }
    }
    
    
    // MARK: - Befinden Statisik
    private var befindenStatistik: some View {
        
        Group {
            getStatsHeaderFor(title: "Befinden")

            HStack(spacing: 8) {
                ForEach(dokuVM.savedDataForStats) { entity in
                    createBarViewFor(barHeight: CGFloat(entity.ratingBefinden), isToday: false)
                }
                // Bar for today
                createBarViewFor(barHeight: dokuVM.getRatingBefindenToday(), isToday: true)
            }
        }
    }
    
    
    // MARK: - Symptome Statisik
    private var symptomeStatistik: some View {
        
        Group {
            getStatsHeaderFor(title: "Symptome")
            
            HStack(spacing: 8) {
                ForEach(dokuVM.savedDataForStats) { entity in
                    createBarViewFor(barHeight: CGFloat(entity.ratingSymptome), isToday: false)
                }
                // Bar for today
                createBarViewFor(barHeight: dokuVM.getRatingSymptomeToday(), isToday: true)
            }
        }
    }
    
    
    // MARK: - Statistik Header
    private func getStatsHeaderFor(title: String) -> some View {
        
        VStack {
            Text(title)
                .customFontTitle()
            
            Text("heute und in den letzten 5 Tagen")
                .foregroundColor(.gray)
                .customFontFootnote()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding([.horizontal, .vertical])
    }
    
    
    // MARK: - Bar View Creator
    private func createBarViewFor(barHeight: CGFloat, isToday: Bool) -> some View {
        Capsule()
            .frame(width: 25, height: CGFloat(barHeight)*30)
            .foregroundColor(isToday ? CustomColor.primary : CustomColor.primaryDark)
    }
}


// MARK: - Preview
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(dokuVM: DokuViewViewModel())
    }
}




