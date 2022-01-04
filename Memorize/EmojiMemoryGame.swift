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
        let shuffedEmojis = emojis.shuffled()
        return MemoryGame<String>(numberOfPrairsOfCards: emojis.count) { pairIndex in
            shuffedEmojis[pairIndex]
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

