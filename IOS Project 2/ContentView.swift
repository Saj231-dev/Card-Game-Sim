//
//  ContentView.swift
//  IOS Project 2
//
//  Created by Student on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataManager.self) private var dataManager: DataManager
    @State private var apiData: String = "placeholder"
    var body: some View {
        VStack {
            Text(apiData)
                .task {
                    let deck = await dataManager.drawCard()
                    if let unwrappedDeck = deck {
                        apiData = unwrappedDeck.cards[0].code
                    }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(DataManager())
}
