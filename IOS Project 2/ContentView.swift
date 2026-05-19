//
//  ContentView.swift
//  IOS Project 2
//
//  Created by Student on 4/28/26.
//

import SwiftUI

struct BoardSlot {
    var faceDownCard: Card?
    var faceUpCard: Card?
}

struct ContentView: View {
    @Environment(DataManager.self) private var dataManager: DataManager

    @State private var board: [BoardSlot] = Array(repeating: BoardSlot(faceDownCard: nil, faceUpCard: nil), count: 10)
    @State private var drawPile: [Card] = []
    @State private var discardPile: [Card] = []

    let cardW = 70.0
    let cardH = 102.0

    var body: some View {
        VStack(spacing: 12) {
            Text("Card game called 'Garbage'")
                .font(.headline)

            boardView(title: "Your Cards", board: board)

            HStack(spacing: 20) {
                Button {
                    drawMain()
                } label: {
                    VStack {
                        backCard
                        Text("Draw (\(drawPile.count))")
                            .font(.caption)
                    }
                }
                .disabled(drawPile.isEmpty)

                Button {
                    drawDiscard()
                } label: {
                    VStack {
                        if let top = discardPile.last {
                            faceCard(card: top)
                        } else {
                            backCard.opacity(0.25)
                        }
                        Text("Discard")
                            .font(.caption)
                    }
                }
                .disabled(discardPile.isEmpty)
            }

            Button("New Game") {
                Task {
                    await newGame()
                }
            }
        }
        .padding()
        .task {
            await newGame()
        }
    }

    func boardView(title: String, board: [BoardSlot]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(cardW), spacing: 8), count: 5), spacing: 8) {
                ForEach(0..<10, id: \.self) { i in
                    if let up = board[i].faceUpCard {
                        faceCard(card: up)
                    } else {
                        backCard
                    }
                }
            }
        }
    }

    var backCard: some View {
        AsyncImage(url: URL(string: "https://deckofcardsapi.com/static/img/back.png")) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
        }
        .frame(width: cardW, height: cardH)
    }

    func faceCard(card: Card) -> some View {
        AsyncImage(url: URL(string: card.image)) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
        }
        .frame(width: cardW, height: cardH)
    }

    func newGame() async {
        let deck = await dataManager.drawCard()
        if let safeDeck = deck {
            let cards = safeDeck.cards.shuffled()
            if cards.count != 52 {
                return
            }

            board = []
            for index in 0..<10 {
                board.append(BoardSlot(faceDownCard: cards[index], faceUpCard: nil))
            }
            drawPile = Array(cards[10...])
            discardPile = []
        } else {
            return
        }

    }

    func drawMain() {
        if let card = drawPile.popLast() {
            play(startCard: card)
        }
    }

    func drawDiscard() {
        if let card = discardPile.popLast() {
            play(startCard: card)
        }
    }

    func play(startCard: Card) {
        var current: Card? = startCard

        while let card = current {
            if card.value == "QUEEN" || card.value == "KING" {
                discardPile.append(card)
                return
            }

            let pos = number(card)
            if let spotNumber = pos {
                let i = spotNumber - 1
                let result = putNumber(card, at: i)

                if isBlocked(result: result) {
                    discardPile.append(card)
                    return
                } else {
                    var replaced: Card? = nil
                    if case let .placed(nextCard) = result {
                        replaced = nextCard
                    }

                    if done() {
                        return
                    }
                    current = replaced
                }
            } else {
                discardPile.append(card)
                return
            }

        }
    }

    enum PutResult {
        case blocked
        case placed(Card?)
    }

    func putNumber(_ card: Card, at i: Int) -> PutResult {
        if board[i].faceUpCard != nil {
            return .blocked
        }

        let replaced = board[i].faceDownCard
        board[i].faceDownCard = nil
        board[i].faceUpCard = card
        return .placed(replaced)
    }

    func isBlocked(result: PutResult) -> Bool {
        if case .blocked = result {
            return true
        }
        return false
    }

    func number(_ card: Card) -> Int? {
        switch card.value {
        case "ACE": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "5": return 5
        case "6": return 6
        case "7": return 7
        case "8": return 8
        case "9": return 9
        case "10": return 10
        default: return nil
        }
    }

    func done() -> Bool {
        for i in 0..<10 {
            let card = board[i].faceUpCard
            if let safeCard = card {
                let n = number(safeCard)
                if let safeN = n {
                    if safeN != i + 1 {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
}

#Preview {
    ContentView()
        .environment(DataManager())
}
