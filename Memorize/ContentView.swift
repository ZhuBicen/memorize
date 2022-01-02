//
//  ContentView.swift
//  Memorize
//
//  Created by Bicen Zhu on 2021/12/26.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
            VStack {
                HStack {
                    Text("Memorize").font(.largeTitle)
                    Text(String(viewModel.score)).font(.largeTitle).foregroundColor(.red)
                }
                Text(viewModel.emojis).font(.largeTitle)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
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
                    newGame
                }
                .padding(.horizontal)
                .font(.largeTitle)
            }.padding(.horizontal)
    }
    
    var newGame : some View {
        
        VStack {
            Button(action: {
                viewModel.newGame()
            }, label:{
               Image(systemName: "plus.circle")
        })
            Text("New").font(.subheadline)
        }
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
                Text(card.content).font(.system(size: 80))
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
