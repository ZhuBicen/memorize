//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Bicen Zhu on 2021/12/26.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
