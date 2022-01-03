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
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(game.cards) { card in
                            CardView(card: card)
                                .aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture {
                                    game.choose(card)
                                }
                        }
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
            }.padding(.horizontal)
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
                        // shape.stroke(lineWidth: 3).foregroundColor(.white)
                        Text(card.content).font(font(in: geometry.size ))
                    } else if card.isMatched {
                        shape.opacity(0)
                    } else {
                        shape.fill().foregroundColor(.red)
                    }
                }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiGameView(game: game)
            .preferredColorScheme(.light)

    }
}
