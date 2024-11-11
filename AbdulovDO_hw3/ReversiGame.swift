//
//  ReversiGame.swift
//  AbdulovDO_hw3
//
//  Created by Jam on 11.11.2024.
//

import Foundation

enum Player {
    case black, white
    case none
}


// все направления от фишки
let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (1, 1), (-1, 1), (1, -1)]



// логика игры
struct ReversiGame {
    var board: [[Player]]
    var currentPlayer: Player
    
    init() {
        // инициализатор класса логики
        self.board = Array(repeating: Array(repeating: .none, count: 8), count: 8)
        self.board[3][3] = .white
        self.board[3][4] = .black
        self.board[4][3] = .black
        self.board[4][4] = .white
        self.currentPlayer = .black
    }
    
    // возможно ли сделать ход
    func isValidMove(row: Int, col: Int) -> Bool {
        guard row >= 0, row < 8, col >= 0, col < 8, board[row][col] == .none else {
            return false
        }
        return canFlipPieces(row: row, col: col)
    }
    
    
    func isGameOver() -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                if isValidMove(row: row, col: col) {
                    return false
                }
            }
        }
        return true
    }
    
    /// функция проверяет, можно ли перевернуть какие-то фишки определенным ходом
    /// т.е. проверяет, что ход возможен
    private func canFlipPieces(row: Int, col: Int) -> Bool {
        
        let opponent = currentPlayer == .black ? Player.white : Player.black
        
        for direction in directions {
            var r = row + direction.0
            var c = col + direction.1
            var hasOpponentInBetween = false
            
            
            while r >= 0, r < 8, c >= 0, c < 8 {
                if board[r][c] == opponent {
                    hasOpponentInBetween = true
                    r += direction.0
                    c += direction.1
                } else if board[r][c] == currentPlayer {
                    if hasOpponentInBetween {
                        return true
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
        }
        return false
    }
    
    // аналогичная функция, но считает конкретное количество
    func countFlippablePieces(row: Int, col: Int) -> Int {
        guard isValidMove(row: row, col: col) else { return 0 }
        
        let opponent = currentPlayer == .black ? Player.white : Player.black
        var totalFlips = 0
        
        for direction in directions {
            var r = row + direction.0
            var c = col + direction.1
            var piecesToFlip = 0
            
            while r >= 0, r < 8, c >= 0, c < 8 {
                if board[r][c] == opponent {
                    piecesToFlip += 1
                    r += direction.0
                    c += direction.1
                } else if board[r][c] == currentPlayer {
                    totalFlips += piecesToFlip
                    break
                } else {
                    break
                }
            }
        }
        return totalFlips
    }

    
    // Простой ИИ (делает рандомный ход)
    mutating func makeSimpleAIMove() {
        for row in 0..<8 {
            for col in 0..<8 {
                if isValidMove(row: row, col: col) {
                    makeMove(row: row, col: col)
                    return
                }
            }
        }
    }
    
    mutating func makeBetterAIMove() {
        var best = -1
        var bestMove: (Int, Int)?
        
        for row in 0..<8 {
            for col in 0..<8 {
                if isValidMove(row: row, col: col) {
                    let flips = countFlippablePieces(row: row, col: col)
                    if flips > best {
                        best = flips
                        bestMove = (row, col)
                    }
                }
            }
        }
        makeMove(row: bestMove!.0, col: bestMove!.1)
    }
    
    // сделать ход
    mutating func makeMove(row: Int, col: Int) {
        guard isValidMove(row: row, col: col) else { return }
        
        board[row][col] = currentPlayer
        
        let opponent = currentPlayer == .black ? Player.white : Player.black
        
        for direction in directions {
            var r = row + direction.0
            var c = col + direction.1
            var piecesToFlip: [(Int, Int)] = []
            
            // Check if there are opponent pieces to flip
            while r >= 0, r < 8, c >= 0, c < 8 {
                if board[r][c] == opponent {
                    piecesToFlip.append((r, c))
                    r += direction.0
                    c += direction.1
                } else if board[r][c] == currentPlayer {
                    for (flipRow, flipCol) in piecesToFlip {
                        board[flipRow][flipCol] = currentPlayer
                    }
                    break
                } else {
                    break
                }
            }
        }
        
        currentPlayer = (currentPlayer == .black) ? .white : .black
    }
    
    func getScore() -> (black: Int, white: Int) {
        var blackCount = 0
        var whiteCount = 0
        for row in board {
            for cell in row {
                if cell == .black {
                    blackCount += 1
                } else if cell == .white {
                    whiteCount += 1
                }
            }
        }
        return (blackCount, whiteCount)
    }
}
