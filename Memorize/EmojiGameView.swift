//
//  ContentView.swift
//  Memorize
//
//  Created by Bicen Zhu on 2021/12/26.
//

import SwiftUI

struct EmojiGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    
    @State var emojiCount = 4
    @State var theme = 0
    @State var dealt = Set<Int>()
    @Namespace var dealingNamespace
    
    private func deal(_ card : EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isDealt(_ card : EmojiMemoryGame.Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay : Double = 0.0
        if let index = game.cards.firstIndex(where : {$0.id == card.id}) {
            delay = Double(index) * (Double(3.00) / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: 0.4).delay(delay)
    }
    
    private func zIndex(of card : EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    private struct CardConstants {
        static let undealtHeight : Double = 90
        static let undealWidth : Double = undealtHeight * 2/3
    }
    
    var body: some View {
        VStack {
                Text("Memorize").font(.largeTitle)
                gameBody
                deckBody
                HStack {
                    shuffle
                    Spacer()
                    newGameButton
                    Spacer()
                    heart
                }
                .padding(.horizontal)
                .font(.largeTitle)
            }.padding(.horizontal)
    }
    
    @ViewBuilder
    func cardViewWrap(_ card : EmojiMemoryGame.Card) -> some View {
        if !isDealt(card) || (card.isMatched && !card.isFaceUp) {
            Color.clear
        } else {
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of : card))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        game.choose(card)
                  }
                }
        }
    }
    
    var gameBody : some View {
        AspectVGrid (items: game.cards, aspectRatio: 2/3) { card in
            cardViewWrap(card)
        }
        .foregroundColor(.red)

    }
    
    
    var deckBody : some View {
        ZStack {
            ForEach(game.cards.filter{!isDealt($0)}){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal:.identity ))
                    .zIndex(zIndex(of : card))
            }
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealtHeight, alignment: .center)
        .foregroundColor(.red)
        .onTapGesture {
                    for card in game.cards {
                        withAnimation (dealAnimation(for: card)) {
                            deal(card)
                        }
                    }
                }
    }
    
    var shuffle : some View {
        VStack {
            Button(action: {
                withAnimation() {
                    game.shuffle()
                }
            }, label:{
               Image(systemName: "car.circle")
        })
            Text("Shuffle").font(.subheadline)
        }
    }
    
    var newGameButton : some View {
        
        VStack {
            Button(action: {
                dealt = []
                game.newGame()
            }, label:{
               Image(systemName: "folder.badge.plus")
        })
            Text("New Game").font(.subheadline)
        }
    }
    
    var pencil : some View {
        VStack {
            Button(action: {
                theme = 1

            }, label:{
               Image(systemName: "pencil.circle")
        })
            Text("Pencil").font(.subheadline)
        }
    }
    
    var heart : some View {
        VStack {
            Button(action: {
                theme = 2
            }, label:{
                Image(systemName: "heart.circle")
        })
            Text("Heart").font(.subheadline)
        }
    }
    
    func shuffledEmojis() -> [String] {
        return []
    }
}


struct CardView : View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader(content: { geometry in
                ZStack{
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:360-90)).opacity(0.3).padding(5)
                    Text(card.content)
                         .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                         .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                         .font(Font.system(size: DrawingConstants.fontSize))
                         .scaleEffect(scale(thatFits: geometry.size))
                }.cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size : CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.8
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiGameView(game: game).preferredColorScheme(.light)
    }
}
