//
//  ContentView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI


// MARK: - ContentView
struct ContentView: View {
    
    @ObservedObject var settingsVM = SettingsViewViewModel()

    init() {
        overrideNavigationAppearance()
        UITableView.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(CustomColor.primaryDark)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
    }
    
    var body: some View {
        
        NavigationView {
            TabView {
                PollenWeatherView(settingsVM: settingsVM)
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("Home")
                    }
                MedicationView()
                    .tabItem {
                        Image(systemName: "pills.fill")
                        Text("Medis")
                    }
                DocumentationView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Doku")
                    }
                SettingsView(settingsVM: settingsVM)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profil")
                    }
            }
            .accentColor(CustomColor.primary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - Tab Menu Appearance
extension UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let newAppearance = UITabBarAppearance()
        newAppearance.configureWithTransparentBackground()
        newAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        tabBar.standardAppearance = newAppearance
    }
}


// MARK: - Navigation Bar Appearance
extension ContentView {

    func overrideNavigationAppearance() {

        // Back Button Color
        let barAppearace = UINavigationBar.appearance()
        barAppearace.tintColor = UIColor(CustomColor.primaryDark)

        // Transparent Background
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.configureWithTransparentBackground()

        // Custom Inline Title
        navigationBarAppearance.titleTextAttributes = [
            .font : UIFont(name: "Futura", size: 20)!,
            NSAttributedString.Key.foregroundColor : UIColor(CustomColor.primaryDark)
        ]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}


// MARK: - Custom Navigation Back Button
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "zurück", style: .plain, target: nil, action: nil)
    }
}


// MARK: - Hide Keyboard Extension
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
