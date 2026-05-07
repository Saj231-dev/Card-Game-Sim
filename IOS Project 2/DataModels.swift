//
//  DataModels.swift
//  IOS Project 2
//
//  Created by Student on 5/5/26.
//

import Foundation

struct Deck: Codable {
    var success: Bool
    var deck_id: String
    var shuffled: Bool
    var remaining: Int
}

struct Card: Codable {
    var code: String
    var image: String
    var value: Int
    var suit: String
}

// Note: This might or might not work, we have to set up the basic api decoding stuff beforehand
