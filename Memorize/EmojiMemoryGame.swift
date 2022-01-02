//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bicen Zhu on 2022/1/2.
//

import SwiftUI

extension String {

 func stringAt(_ i: Int) -> String {
   return String(Array(self)[i])
 }

 func charAt(_ i: Int) -> Character {
  return Array(self)[i]
 }
}

class EmojiMemoryGame : ObservableObject {
    static let emojis = [
        "🐧 🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼 🐻‍❄️ 🐨 🐯 🦁 🐮 🐷 🐽 🐸 🐵 🙈 🙉 🙊 🐒 🐔 🐧 🐦 🐤 🐣 🐥 🦆 🦅 🦉 🦇 🐺 🐗 🐴 🦄",
        "🍏 🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🫐 🍈 🍒 🍑 🥭 🍍 🥥 🥝 🍅 🍆 🥑 🥦 🥬 🥒 🌶 🫑 🌽 🥕 🫒 🧄 🧅 🥔 🍠 🥐 🥯 🍞",
        "⚽️ 🏀 🏈 ⚾️ 🥎 🎾 🏐 🏉 🥏 🎱 🪀 🏓 🏸 🏒 🏑 🥍 🏏 🪃 🥅 ⛳️ 🪁 🏹 🎣 🤿 🥊 🥋 🎽 🛹 🛼 🛷 ⛸ 🥌 🎿 ⛷ 🏂",
        "⌚️ 📱 📲  ⌨️ 🖥 🖨 🖱 🖲 🕹 🗜 💽 💾 💿 📀 📼 📷 📸 📹 🎥 📽 🎞 📞 ☎️ 📟 📠 📺 📻 🎙 ",
        "❤️ 🧡 💛 💚 💙 💜 🖤 🤍 🤎 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💟 ☮️ ✝️ ☪️ 🕉 ☸️ ✡️ 🔯 🕎 ☯️",
        "✢ ✣ ✤ ✥ ✦ ✧ ★ ☆ ✯ ✡︎ ✩ ✪ ✫ ✬ ✭ ✮ ✶ ✷ ✵ ✸ ✹ → ⇒ ⟹ ⇨ ⇾ ➾ ⇢ ☛ ☞ ➔ ➜ ➙ ",
        "🟢 🔵 🟣 ⚫️ ⚪️ 🟤 🔺 🔻 🔸 🔹 🔶 🔷 🔳 🔲 ▪️ ▫️ ◾️ ◽️ ◼️ ◻️ 🟥 🟧 🟨 🟩 🟦 🟪 ⬛️ ⬜️ 🟫 "
    ]
    static let themeNames = [
        "Animal", "Fruit", "Sports", "Electronic", "Heart", "Poke", "Geography"
    ]
    
    static func createMemoryGame() -> MemoryGame<String> {
        let pairNum = 8
        let theme = Int.random(in: 0..<emojis.count)
        let selectedEmojis = Array(emojis[theme].filter{$0 != " "}.shuffled()[0..<pairNum])
        let allSelectedEmojis = selectedEmojis.shuffled() + selectedEmojis.shuffled()

        return MemoryGame<String>(numberOfCards: pairNum * 2, theme: themeNames[theme], emojis: String(selectedEmojis)) { index in
            String(allSelectedEmojis[index])
        }
    }
        
    @Published private(set) var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var theme: String {
        model.theme
    }
    
    var score: Int {
        return model.score
    }
    
    var emojis: String {
        return model.emojis
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
}

