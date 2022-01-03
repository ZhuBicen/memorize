//
//  MemoryGaem.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable {
    var cards : Array<Card>
    
    private var indexOfTheOneAndTheOnlyFaceUpCard : Int? {
        get{
            cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set{
            cards.indices.forEach{cards[$0].isFaceUp = $0 == newValue}
        }
        
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialChosenIndex = indexOfTheOneAndTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialChosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialChosenIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndTheOnlyFaceUpCard = chosenIndex
            }
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
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}


extension Array {
    var oneAndOnly : Element? {
        if self.count == 1 {
            return self.first
        }
        return nil
    }
}
