//
//  ViewController.swift
//  TicTacToe
//
//  Created by Alireza Moghaddam on 2019-01-28.
//  Copyright © 2019 Alireza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gameOver = false
    
    var turn = 1    //1 is O  2 is X
    
    var board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var winning_conditions = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print("Winning Case")
                gameOver = true
            }
        }
        
        
        
        
            print(board)
        }
        
    }
}

