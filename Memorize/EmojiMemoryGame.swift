//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    static let emojis = ["🍇", "🍞", "🥗", "🥘", "🌮", "🥫", "♠︎", "⚽️", "🛼", "🥎", "🛷", "🏉", "🤸🏻‍♀️", "🌕", "🪁", "🥍", "⛸"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPrairsOfCards: 8) { pairIndex in
                emojis[pairIndex]
        }
    }
    
    @Published private(set) var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
}

