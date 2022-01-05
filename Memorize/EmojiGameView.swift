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
                        game.choose(item)
                    }
                }
                Spacer(minLength: 20)
                HStack {
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
                    let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    if card.isFaceUp {
                        shape.fill().foregroundColor(.white)
                        shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:360-90)).opacity(0.3).padding(5)
                        Text(card.content).font(font(in: geometry.size ))
                    } else if card.isMatched {
                        shape.opacity(0)
                    } else {
                        shape.fill()
                    }
                }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
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
