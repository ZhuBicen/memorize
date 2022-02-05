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
    mutating func shuffle() {
        cards.shuffle()
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
        var isFaceUp: Bool = true {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: Bonus time
        // this could give matching bonus time
        // if user matches the card
        // before certain amount of time passes during which the card is face up
        
        // can be zero which means no bonus available for this card
        var bonusTimeLimit : TimeInterval = 6
        
        // how long this card has ever been face up
        
        private var faceUpTime : TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time is card is face up and is still face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been faced up in the past
        var pastFaceUpTime : TimeInterval = 0
        
        // how much time left before bonus opportunity time runs out
        var bonusTimeRemaining : TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of bonus time remainning
        var bonusRemaining : Double {
            ( bonusTimeLimit > 0 && bonusTimeRemaining > 0 ) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus : Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime : Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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
