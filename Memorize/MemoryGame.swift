//
//  MemoryGaem.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable {
    var cards : Array<Card>
    var theme : String
    var score : Int = 0
    var emojis : String
    
    private var lastChosenFacedUpIndex : Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialChosenIndex = lastChosenFacedUpIndex {
                if cards[chosenIndex].content == cards[potentialChosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialChosenIndex].isMatched = true
                    score += 2
                } else {
                    if cards[chosenIndex].isSeen && cards[potentialChosenIndex].isSeen {
                        score -= 2
                    } else if (cards[potentialChosenIndex].isSeen) {
                        score -= 1
                    } else if (cards[chosenIndex].isSeen) {
                        score -= 1
                    }
                    cards[chosenIndex].isSeen = true
                    cards[potentialChosenIndex].isSeen = true
                }
                lastChosenFacedUpIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                lastChosenFacedUpIndex = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    func index(of card: Card) -> Int?{
        for index in 0..<cards.count {
            if (cards[index].id == card.id) {
                return index
            }
        }
        return nil
    }
    
    init(numberOfCards: Int, theme: String, emojis: String, creatCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards x 2
        for index in 0..<numberOfCards {
            let content = creatCardContent(index)
            cards.append(Card(content: content, id: index))
        }
        self.emojis = emojis
        self.theme = theme
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
