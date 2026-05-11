//
//  IOS_Project_2App.swift
//  IOS Project 2
//
//  Created by Student on 4/28/26.
//

import SwiftUI

@main
struct IOS_Project_2App: App {
    @State private var dataManager = DataManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataManager)
        }
    }
}
