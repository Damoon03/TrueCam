//
//  ContentView.swift
//  TrueCam
//
//  Created by Damoon saber on 2/20/1405 AP.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    @State var selection = 1
    /*
    @StateObject private var countriesStore = CountriesStore()
    @State private var showPicker = false
    @State private var selectedCountry: Country?
    */
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TabView(selection: $selection) {
             
             LeftMenu(selection: $selection)
             .tag(0)
             
             FeedView(selection: $selection)
             .tag(1)
             
             Profile(selection: $selection)
             .tag(2)
             }
             .tabViewStyle(.page(indexDisplayMode: .never))
             .onChange(of: selection) { oldValue, newValue in
             simpleSuccess()
             
             }
            
           /* Button(selectedCountry.map { "\($0.flag) \($0.displayDialCode)" } ?? "Select Country") {
                showPicker = true
            }
            .sheet(isPresented: $showPicker) {
                CountryPickerView(store: countriesStore) { country in
                    selectedCountry = country
                }
            }
            */
        }
        
    }
    
    #Preview {
        ContentView()
    }
}
