//
//  ViewController.swift
//  TicTacToe
//
//  Created by Alireza Moghaddam on 2019-01-28.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var saveGameButton: UIButton!
	@IBOutlet weak var loadGameButton: UIButton!

	@IBOutlet var buttons: [UIButton]!

	var gameOver = false
	var turn = 1    //1 is O  2 is X
    var board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	var gameStateBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	var gameStateTurn = 1
    var gameStateGameOver = false
    var winning_conditions = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		resultLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func btnPressed(_ sender: AnyObject) {
        
       if board[sender.tag - 1] == 0 && gameOver != true
       {
           if turn == 1
           {
                sender.setImage(UIImage(named: "nought.png"), for: [])
                board[sender.tag - 1] = 1
            
                turn = 2
            }
           else{
                sender.setImage(UIImage(named: "cross.png"), for: [])
                board[sender.tag - 1] = 2
            
                turn = 1
            }
        
			for win_cond in winning_conditions{

				if board[win_cond[0]] != 0 && board[win_cond[0]] == board[win_cond[1]] && board[win_cond[1]] == board[win_cond[2]]
				{
					if turn == 1 {
						resultLabel.text = "Xs won"
					}
					else{
						resultLabel.text = "Os won"
					}
					gameOver = true
				}
				else if !board.contains(0){
					gameOver = true
					resultLabel.text = "Draw"
				}
			}
		}
    }

	@IBAction func newGame(_ sender: Any) {
		resultLabel.text = ""
		board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		gameOver = false
		for i in 0..<board.count {
			switch(board[i]){
			case 1:
				buttons[i].setImage(UIImage(named: "nought.png"), for: [])
			case 2:
				buttons[i].setImage(UIImage(named: "cross.png"), for: [])
			default:
				buttons[i].setImage(nil, for: [])
			}
		}
	}

	@IBAction func saveGame(_ sender: Any) {
		gameStateBoard = board
		gameStateTurn = turn
		gameStateGameOver = gameOver
	}

	@IBAction func loadGame(_ sender: Any) {
		gameOver = false
		board = gameStateBoard
		turn = gameStateTurn
		gameOver = gameStateGameOver
		for i in 0..<board.count {
			switch(board[i]){
				case 1:
					buttons[i].setImage(UIImage(named: "nought.png"), for: [])
				case 2:
					buttons[i].setImage(UIImage(named: "cross.png"), for: [])
				default:
					buttons[i].setImage(nil, for: [])
			}
		}
	}
}

