//
//  ContentView.swift
//  Memorize
//
//  Created by Bicen Zhu on 2021/12/26.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    @State var emojiCount = 4
    @State var theme = 0
    
    var body: some View {
            VStack {
                Text("Memorize").font(.largeTitle)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture {
                                    viewModel.choose(card)
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
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 30)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3).foregroundColor(.gray)
                // shape.stroke(lineWidth: 3).foregroundColor(.white)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill().foregroundColor(.red)
            }
        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
//            .preferredColorScheme(.dark)
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
