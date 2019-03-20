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
    var scoreLabel: SKLabelNode?
	var gameOverLabel: SKLabelNode?
    
    var mario: SKSpriteNode?  //SKSpriteNode is an onscreen graphical element that can be initialized from an image or a solid color. SpriteKit adds functionality to its ability to display images. For more information:
    //https://developer.apple.com/documentation/spritekit/skspritenode
    
    
    var coinTimer: Timer?
	var cloudTimer: Timer?
	var bombTimer: Timer?
   
    var score = 0

	var marioLivesLeft = 3
    
    let marioCategory: UInt32 = 0x1 << 1
    let coinCategory: UInt32 = 0x1 << 2
	let cloudCategory: UInt32 = 0x1 << 3
	let bombCategory: UInt32 = 0x1 << 4
	var marioLives: [SKSpriteNode] = []

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self  //The driver of the physics engine in a scene; it exposes the ability for you to configure and query the physics system.
		initMarioLifes()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        self.view!.addGestureRecognizer(panGestureRecognizer)

        mario = childNode(withName: "mario") as? SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
		gameOverLabel = childNode(withName: "gameOverLabel") as? SKLabelNode
		gameOverLabel?.isHidden = true

        mario?.physicsBody?.categoryBitMask = marioCategory
		mario?.physicsBody?.collisionBitMask = marioCategory
        mario?.physicsBody?.contactTestBitMask = coinCategory

        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in self.createCoin()})
		cloudTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {(timer) in self.createCloud()})
		bombTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {(timer) in self.createBomb()})
    }

    @objc func handlePanFrom(_ recognizer: UIPanGestureRecognizer) {
        var locationOfBeganTap: CGPoint = CGPoint(x: 0, y: 0)
        var locationOfEndTap: CGPoint = CGPoint(x: 0, y: 0)
        let velocity = recognizer.velocity(in: view)

        if recognizer.state == UIGestureRecognizer.State.began {
            locationOfBeganTap = recognizer.location(in: view)
            print("Start Location: \(locationOfBeganTap)")

        } else if recognizer.state == UIGestureRecognizer.State.ended {
            locationOfEndTap = recognizer.location(in: view)
            if(marioLivesLeft>0){
                mario?.physicsBody?.applyForce(CGVector(dx: (velocity.x*2 + locationOfEndTap.x)*5, dy: (abs(velocity.y*1.25)  + locationOfEndTap.y)*25))
            }
            print("End location: \(locationOfEndTap)")
            print("Velocity: \(velocity)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(marioLivesLeft>0){
//            mario?.physicsBody?.applyForce(CGVector(dx:0, dy: 30000))
        }
    }

	func initMarioLifes(){
		for i in 0...2{
			let marioLife = SKSpriteNode(imageNamed: "superMario")
			let newX = CGFloat(50 + 70*i)
			marioLife.size = CGSize(width: 58, height: 74)
			marioLife.position = CGPoint (x: -size.width/2+newX, y: size.height/2 - 50)
			marioLives.append(marioLife)
			self.addChild(marioLife)
		}
	}
    
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 100, height: 100)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        
        coin.physicsBody?.categoryBitMask = coinCategory
		coin.physicsBody?.collisionBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = marioCategory

        addChild(coin)
        
        let maxY = size.height / 2 - coin.size.height / 2
        let minY = -size.height / 3 + coin.size.height / 2
        let range = maxY - minY
        
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        coin.position = CGPoint(x: size.width / 2 + coin.size.width / 2, y: coinY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width, y: 0, duration: 4)
        let mySeq = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        coin.run(mySeq)
    }

	func createCloud() {
		let cloud = SKSpriteNode(imageNamed: "cloud")
		cloud.size = CGSize(width: 150, height: 100)
		cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
		cloud.physicsBody?.affectedByGravity = false

		cloud.physicsBody?.categoryBitMask = cloudCategory
		cloud.physicsBody?.collisionBitMask = cloudCategory
		cloud.physicsBody?.contactTestBitMask = cloudCategory

		addChild(cloud)

		let maxY = size.height / 2.5 - cloud.size.height / 2
		let minY = size.height / 6 + cloud.size.height / 2

		let range = maxY - minY
		let cloudY = maxY - CGFloat(arc4random_uniform(UInt32(range)))

		cloud.position = CGPoint(x: size.width / 2 + cloud.size.width / 2, y: cloudY)

		let moveLeft = SKAction.moveBy(x: -size.width - cloud.size.width, y: 0, duration: 5)
		let cloudSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
		cloud.run(cloudSequence)
	}

	func createBomb(){
		let bomb = SKSpriteNode(imageNamed: "bomb")
		bomb.size = CGSize(width:150, height: 150)
		bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
		bomb.physicsBody?.affectedByGravity = false

		bomb.physicsBody?.categoryBitMask = bombCategory
		bomb.physicsBody?.collisionBitMask = bombCategory
		bomb.physicsBody?.contactTestBitMask = marioCategory

		addChild(bomb)

		let maxY = size.height / 2 - bomb.size.height / 2
		let minY = -size.height / 3 + bomb.size.height / 2
		let range = maxY - minY
		let bombY = maxY - CGFloat(arc4random_uniform(UInt32(range)))

		bomb.position = CGPoint(x: size.width / 2 + bomb.size.width / 2, y: bombY)
		let moveLeft = SKAction.moveBy(x: -size.width - bomb.size.width, y: 0, duration: 4)
		let bombSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
		bomb.run(bombSequence)
	}

    func didBegin(_ contact: SKPhysicsContact) {
        /*
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
        }
        */
        
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
        }

		if contact.bodyA.categoryBitMask == marioCategory && contact.bodyB.categoryBitMask == bombCategory{
			contact.bodyB.node?.removeFromParent()
			marioLivesLeft -= 1
			if marioLivesLeft >= 0{
				marioLives[marioLivesLeft].removeFromParent()
			}
			if(marioLivesLeft == 0){
				print("Game over!")
				coinTimer?.invalidate()
				bombTimer?.invalidate()
				cloudTimer?.invalidate()
				gameOverLabel?.isHidden = false
				self.backgroundColor = .darkGray
			}
		}


		scoreLabel?.text = "Score: \(score)"
    }
    
  
}
