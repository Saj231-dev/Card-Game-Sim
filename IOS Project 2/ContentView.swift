//
//  ContentView.swift
//  IOS Project 2
//
//  Created by Student on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataManager.self) private var dataManager: DataManager
    @State private var apiData = "placeholder"
    var body: some View {
        VStack {
            Text(apiData)
                .task {
                    let urlStr = dataManager.apiURL + "new"
                    let url: URL? = URL(string: urlStr)
                    guard let urlUnwrapped = url else {
                        return
                    }
                    do {
                        let (data, response) = try await URLSession.shared.data(from: urlUnwrapped)
                        if let responseConverted = response as? HTTPURLResponse {
                            print("status code: \(responseConverted.statusCode)")
                        }
                        let deck: Deck = try JSONDecoder().decode(Deck.self, from: data)
                        let deckID = deck.deck_id
                            print(deck)
                    } catch let error {
                        print(error)
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
