//
//  MemoryGaem.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable {
    var cards : Array<Card>
    
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

        print("Cards .\(cards)")
    }
    
    func index(of card: Card) -> Int?{
        for index in 0..<cards.count {
            if (cards[index].id == card.id) {
                return index
            }
        }
        return nil
    }
    
    init(numberOfPrairsOfCards: Int, creatCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards x 2
        for pariIndex in 0..<numberOfPrairsOfCards {
            let content: CardContent = creatCardContent(pariIndex)
            cards.append(Card(content: content, id: pariIndex * 2))
            cards.append(Card(content: content, id: pariIndex * 2 + 1))
            
        }
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
