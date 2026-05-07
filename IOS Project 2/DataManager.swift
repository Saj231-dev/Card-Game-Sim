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
}
