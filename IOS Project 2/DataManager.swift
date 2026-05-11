//
//  DataManager.swift
//  IOS Project 2
//
//  Created by Student on 4/30/26.
//

import SwiftUI

@Observable
class DataManager {
    let apiURL = "https://deckofcardsapi.com/api/deck/"
    var deckSize = 2
    
    init(deckSize: Int = 2) {
        self.deckSize = deckSize
    }
    
    func jsonDecoding(subType: subType) async {
        let urlStr = if subType == .deck { self.apiURL + "new" } else { "h" }
        let url: URL? = URL(string: urlStr)
        guard let urlUnwrapped = url else {
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: urlUnwrapped)
            if let responseConverted = response as? HTTPURLResponse {
                print("status code: \(responseConverted.statusCode)")
            }
            if subType == .deck {
                let deck: Deck = try JSONDecoder().decode(Deck.self, from: data)
                let deckID = deck.deck_id
                print(deck)
            }
        } catch let error {
            print(error)
        }
    }
}
