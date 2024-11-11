//
//  ContentView.swift
//  AbdulovDO_hw3
//
//  Created by Jam on 11.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var game = ReversiGame()
    @State private var gameOver = false
    @State private var overMessage = ""
    @State private var againstAI = false
    @State private var betterAI = false

    var body: some View {
        
        Toggle("Play against AI", isOn: $againstAI)
            .padding()
        Toggle("Use better AI", isOn: $betterAI)
            .padding()
        VStack {
            Text("Current Player: \(game.currentPlayer == .black ? "Black" : "White")")
                .font(.headline)
                .padding()

            VStack(spacing: 5) {
                ForEach(0..<8, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<8, id: \.self) { col in
                            Button(action: {
                                self.handleMove(row: row, col: col)
                            }) {
                                Circle()
                                    .foregroundColor(self.circleColor(for: game.board[row][col]))
                                    .frame(width: 40, height: 40)
                                    
                                    .background(self.isValidMove(row: row, col: col) ? Color.green.opacity(0.3) : Color.clear, in: .circle)
                                    .overlay(
                                        Circle().stroke(Color.black, lineWidth: 1)
                                    )
                            }
                            .disabled(game.board[row][col] != .none && !self.isValidMove(row: row, col: col))
                        }
                    }
                }
            }
            .padding()

            HStack {
                Text("Black: \(game.getScore().black)")
                Spacer()
                Text("White: \(game.getScore().white)")
            }
            .padding()

            // кнопка перезапуска
            Button(action: {
                self.game = ReversiGame()
            }) {
                Text("Restart Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        // алерт завершения игры
        .alert(isPresented: $gameOver ) {
            Alert(title: Text("Game ended"), message: Text(overMessage), dismissButton: .default(Text("Restart"), action: {gameOver = false; self.game = ReversiGame()}))
        }
    }
    

    private func circleColor(for player: Player) -> Color {
        switch player {
        case .black:
            return .black
        case .white:
            return .white
        default:
            return .gray.opacity(0.3)
        }
    }

    private func gameResult() {
        if game.getScore().black > game.getScore().white {
            overMessage = """
            Black wins! Score: \(game.getScore().black) : \(game.getScore().white)
            """
        } else if game.getScore().black < game.getScore().white {
            overMessage = """
            Black wins! Score: \(game.getScore().black) : \(game.getScore().white)
            """
        } else {
            overMessage = """
            Draw! Score for both: \(game.getScore().black) 
            """
        }
    }
    
    private func handleMove(row: Int, col: Int) {
        game.makeMove(row: row, col: col)
        
        
        // проверка на завершение игры
        if (game.isGameOver()) {
    
            gameResult()
        }
        
        if againstAI && game.currentPlayer == .black {
          
            if (betterAI) {
                game.makeBetterAIMove()
            } else {
                game.makeSimpleAIMove()
            }
        }
        
        // повторная проверка после хода ИИ
        if (game.isGameOver()) {
            gameResult()
        }
    }
    
    
    private func isValidMove(row: Int, col: Int) -> Bool {
        return game.isValidMove(row: row, col: col)
    }
}


#Preview {
    ContentView()
}


