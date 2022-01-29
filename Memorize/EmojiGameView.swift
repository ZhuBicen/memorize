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
    
    var body: some View {
            VStack {
                Text("Memorize").font(.largeTitle)
                AspectVGrid (items: game.cards, aspectRatio: 2/3) {
                    item in CardView(card: item).padding(4).onTapGesture {
                        withAnimation(.easeInOut(duration: 2)) {
                            game.choose(item)
                        }
                    }
                }
                Spacer(minLength: 20)
                HStack {
                    shuffle
                    car
                    Spacer()
                    pencil
                    Spacer()
                    heart
                }
                .padding(.horizontal)
                .font(.largeTitle)
            }.padding(.horizontal).foregroundColor(.red)
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
    
    var car : some View {
        
        VStack {
            Button(action: {
                theme = 0
            }, label:{
               Image(systemName: "car.circle")
        })
            Text("Car").font(.subheadline)
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
