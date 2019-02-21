//
//  GameScene.swift
//  Mario2
//
//  Created by Alireza Moghaddam on 2019-02-02.
//  Copyright © 2019 Alireza. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
	var player1HealthLabel: SKLabelNode?
	var player2HealthLabel: SKLabelNode?
	var gameOverLabel: SKLabelNode?

	var gameOver = false
	var player1: SKSpriteNode?
	var player2: SKSpriteNode?
    var mario: SKSpriteNode?
	var turn = 1
	var player1Health =  100
	var player2Health = 100

	var barrelLength : CGFloat = 20
	var barrelDiameter : CGFloat = 4
	var cannonRadius : CGFloat = 7
	var ballSpeed : CGFloat = 5
    
	let player1Category: UInt32 = 0x1 << 1
	let player2Category: UInt32 = 0x1 << 2
	let ballCategory: UInt32 = 0x1 << 3

    override func didMove(to view: SKView) {
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        physicsWorld.contactDelegate = self  //The driver of the physics engine in a scene; it exposes the ability for you to configure and query the physics system.
		player1 = childNode(withName: "player1") as? SKSpriteNode
		player2 = childNode(withName: "player2") as? SKSpriteNode

		gameOverLabel = childNode(withName: "gameOverLabel") as? SKLabelNode
		player1HealthLabel = childNode(withName: "player1HealthLabel") as? SKLabelNode
		player2HealthLabel = childNode(withName: "player2HealthLabel") as? SKLabelNode

		player1HealthLabel?.text = "Player 1: \(player1Health)%"
		player2HealthLabel?.text = "Player 2: \(player2Health)%"
		gameOverLabel?.isHidden = true

		player1?.physicsBody?.categoryBitMask = player1Category
		player1?.physicsBody?.collisionBitMask = player1Category

		player2?.physicsBody?.categoryBitMask = player2Category
		player2?.physicsBody?.collisionBitMask = player2Category
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if(!gameOver){
			for touch in touches {
				let location = touch.location(in: self)
				print(location.x)
				shoot(touchX: location.x, touchY: location.y)
				if turn == 1{
					turn = 2
				} else{
					turn = 1
				}
			}
		}
    }

	func shoot(touchX: CGFloat, touchY: CGFloat){
		let ball = SKShapeNode(circleOfRadius: 15)
		ball.name = "Ball"
		ball.fillColor = UIColor.red
		ball.strokeColor = UIColor.red
		ball.physicsBody?.linearDamping = 0

		if turn == 1{
			ball.position = CGPoint(
				x: player1!.position.x +
					(cannonRadius + barrelLength) * cos(1),
				y: player1!.position.y +
					(cannonRadius + barrelLength) * sin(1)
			)

			ball.physicsBody = SKPhysicsBody(circleOfRadius: barrelDiameter / 2)

			ball.physicsBody?.velocity = CGVector(dx:  3 * (touchX + size.width/2), dy:  ballSpeed * touchY)

			ball.physicsBody?.categoryBitMask = ballCategory
			ball.physicsBody?.contactTestBitMask = player2Category
		} else if turn == 2{
			ball.position = CGPoint(
				x: player2!.position.x +
					(cannonRadius + barrelLength) * cos(2),
				y: player2!.position.y +
					(cannonRadius + barrelLength) * sin(1)
			)

			ball.physicsBody = SKPhysicsBody(circleOfRadius: barrelDiameter / 2)

			ball.physicsBody?.velocity = CGVector(dx: 3 * (touchX - size.width/2), dy:  ballSpeed * touchY)

			ball.physicsBody?.categoryBitMask = ballCategory
			ball.physicsBody?.contactTestBitMask = player1Category
		}
		self.addChild(ball)
	}

    func didBegin(_ contact: SKPhysicsContact) {
        /*
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
        }
        */


		if contact.bodyA.categoryBitMask == player2Category && contact.bodyB.categoryBitMask == ballCategory{
			player2Health -= 20
			player2HealthLabel?.text = "Player 2: \(player2Health)%"
			contact.bodyB.node?.removeFromParent()
		}

		if contact.bodyA.categoryBitMask == player1Category && contact.bodyB.categoryBitMask == ballCategory{
			player1Health -= 20
			player1HealthLabel?.text = "Player 1: \(player1Health)%"
			contact.bodyB.node?.removeFromParent()
		}

		if player1Health == 0 || player2Health == 0 {
			print("Game over!")
			gameOver = true
			gameOverLabel?.isHidden = false
			self.backgroundColor = .darkGray
		}

    }
    
  
}
