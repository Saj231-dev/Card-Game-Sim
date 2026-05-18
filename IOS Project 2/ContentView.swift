//
//  ContentView.swift
//  IOS Project 2
//
//  Created by Student on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataManager.self) private var dataManager: DataManager
    @State private var cards: [Card] = []
    @State private var onClick: Bool = false
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(cards) { card in
                        AsyncImage(url: URL(string: card.image))
                    }
                }
            }
            Button("Shuffle") {
                onClick = true
            }
            
            //Button{
                //Task {
                    //if let deck = await dataManager.drawCard() {
                        //cards = deck.deck.cards
                    //}
                //}
            //} label: {
                //Text("Draw Cards")
        //}
        }
        .task {
            var deck = await dataManager.drawCard()
            if let unwrappedDeck = deck {
                for card in unwrappedDeck.cards {
                    cards.append(card)
                }
                if onClick {
                    deck = await dataManager.shuffle(deck: unwrappedDeck)
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
