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
    
    var mario: SKSpriteNode?  //SKSpriteNode is an onscreen graphical element that can be initialized from an image or a solid color. SpriteKit adds functionality to its ability to display images. For more information:
    //https://developer.apple.com/documentation/spritekit/skspritenode
    
    
    var coinTimer: Timer?
	var cloudTimer: Timer?
   
    var score = 0
    
    let marioCategory: UInt32 = 0x1 << 1
    let coinCategory: UInt32 = 0x1 << 2
	let cloudCategory: UInt32 = 0x1 << 3
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self  //The driver of the physics engine in a scene; it exposes the ability for you to configure and query the physics system.
       
        mario = childNode(withName: "mario") as? SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode

        mario?.physicsBody?.categoryBitMask = marioCategory
		mario?.physicsBody?.collisionBitMask = marioCategory
        mario?.physicsBody?.contactTestBitMask = coinCategory
        
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in self.createCoin()})
		cloudTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {(timer) in self.createCloud()})
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mario?.physicsBody?.applyForce(CGVector(dx:0, dy: 40000))
        
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

		print(maxY)
		print(minY)
		let range = maxY - minY
		let cloudY = maxY - CGFloat(arc4random_uniform(UInt32(range)))

		cloud.position = CGPoint(x: size.width / 2 + cloud.size.width / 2, y: cloudY)

		let moveLeft = SKAction.moveBy(x: -size.width - cloud.size.width, y: 0, duration: 5)
		let cloudSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
		cloud.run(cloudSequence)
	}

    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact!")
        /*
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
        }
        */
        
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
        }
		scoreLabel?.text = "Score: \(score)"
    }
    
  
}
