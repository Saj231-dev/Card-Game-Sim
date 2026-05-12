//
//  DataModels.swift
//  IOS Project 2
//
//  Created by Student on 5/5/26.
//

import Foundation

struct DeckID: Codable {
    var deck_id: String
}

struct Deck: Codable {
    var cards: [Card]
    var remaining: Int
}

struct Card: Codable, Identifiable {
    var id = UUID()
    var code: String
    var image: String
    var value: Int
    var suit: String
}

enum subType {
    case deck
    case card
}

// Note: This might or might not work, we have to set up the basic api decoding stuff beforehand
