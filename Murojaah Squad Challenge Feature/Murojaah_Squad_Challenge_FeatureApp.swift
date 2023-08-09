//
//  Murojaah_Squad_Challenge_FeatureApp.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import SwiftUI

@main
struct Murojaah_Squad_Challenge_FeatureApp: App {
    @StateObject private var apiViewModel = APIViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiViewModel)
        }
    }
}
