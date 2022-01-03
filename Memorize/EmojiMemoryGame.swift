//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["🍇", "🍞", "🥗", "🥘", "🌮", "🥫", "♠︎", "⚽️", "🛼", "🥎", "🛷", "🏉", "🤸🏻‍♀️", "🌕", "🪁", "🥍", "⛸"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPrairsOfCards: 8) { pairIndex in
                emojis[pairIndex]
        }
    }
    
    @Published private(set) var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
}

