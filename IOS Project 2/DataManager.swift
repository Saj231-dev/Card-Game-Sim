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
    var drawAmount = 2
    
    init(drawAmount: Int = 2) {
        self.drawAmount = drawAmount
    }
    
    private func getDeckID() async -> DeckID? {
        let urlStr = self.apiURL + "new"
        let url: URL? = URL(string: urlStr)
        guard let urlUnwrapped = url else {
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: urlUnwrapped)
            if let responseConverted = response as? HTTPURLResponse {
                print("status code: \(responseConverted.statusCode)")
            }
            let deckID: DeckID = try JSONDecoder().decode(DeckID.self, from: data)
            return deckID
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func drawCard() async -> Deck? {
        let deckID = await getDeckID()
        guard let unwrappedID = deckID else {
            return nil
        }
        let cardURL = apiURL + unwrappedID.deck_id + "/draw/?count=\(self.drawAmount)"
        let url: URL? = URL(string: cardURL)
        guard let urlUnwrapped = url else {
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: urlUnwrapped)
            if let responseConverted = response as? HTTPURLResponse {
                print("status code: \(responseConverted.statusCode)")
            }
            let deck: Deck = try JSONDecoder().decode(Deck.self, from: data)
            return deck
        } catch let error {
            print(error)
            return nil
        }
    }
}
