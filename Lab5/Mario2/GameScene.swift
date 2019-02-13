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
    var yourScoreLabel : SKLabelNode?
    var finalScoreLabel : SKLabelNode?
    
    var mario: SKSpriteNode?  //SKSpriteNode is an onscreen graphical element that can be initialized from an image or a solid color. SpriteKit adds functionality to its ability to display images. For more information:
    //https://developer.apple.com/documentation/spritekit/skspritenode
    
    
    var coinTimer: Timer?
    var birdTimer: Timer?
   
    var score = 0
    
    let marioCategory: UInt32 = 0x1 << 1 //=1
    let coinCategory: UInt32 = 0x1 << 2 //=2
    let groundCategory: UInt32 = 0x1 << 3 // 32
    let platformCategory: UInt32 = 0x1 << 4 // 16
    let birdCategory : UInt32 = 0x1 << 5   //32
    let dummyCategory: UInt32 = 0x1 << 6 // 64
    
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self  //The driver of the physics engine in a scene; it exposes the ability for you to configure and query the physics system
       
        mario = childNode(withName: "mario") as? SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        
        mario?.physicsBody?.categoryBitMask = marioCategory
        mario?.physicsBody?.collisionBitMask = groundCategory
        mario?.physicsBody?.contactTestBitMask = coinCategory | birdCategory
        
        var marioRun : [SKTexture] = []
        for number in 1...4 {
            marioRun.append(SKTexture(imageNamed: "frame-\(number).png"))
        }
        mario?.run(SKAction.repeatForever(SKAction.animate(with: marioRun, timePerFrame: 0.2)))
        
        startTimers()
        createGround()
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if scene?.isPaused == false {   //If the screen is not on "Game Over" mode, then apply the force to mario
            mario?.physicsBody?.applyForce(CGVector(dx: 0, dy: 30000))
        }
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            //Iterate through all elements on the scene to see if the click event has happened on the "Play/Resume" button
            for node in theNodes {
                if node.name == "play" {
                    // Restart the game
                    score = 0
                    node.removeFromParent()
                    finalScoreLabel?.removeFromParent()
                    yourScoreLabel?.removeFromParent()
                    scene?.isPaused = false
                    scoreLabel?.text = "Score: \(score)"
                    startTimers()
                }
            }
        }
        
    }
    
    
    func createBird() {

       /*
         To Do:
         
         Create a bird and add animation to the bird. The frames for the animation is given to you under "Assets" folder
         
        */
      
    }
    
    
    func createGround()
    {
        let tmp_element = SKSpriteNode(imageNamed: "ground.jpg")
        let numberOfElements = Int(size.width / tmp_element.size.width) + 1
        
        for number in 0...numberOfElements {
            let element = SKSpriteNode(imageNamed: "ground.jpg")
            element.size = CGSize(width: 255, height: 120)
            element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
            element.physicsBody?.categoryBitMask = groundCategory
            element.physicsBody?.collisionBitMask = marioCategory
            element.physicsBody?.affectedByGravity = false
            element.physicsBody?.isDynamic = false
            element.physicsBody?.allowsRotation = false
            addChild(element)
            
            let elementX = -size.width / 2 + element.size.width / 2  + element.size.width * CGFloat(number)
            element.position = CGPoint(x: elementX, y: -size.height / 2 + element.size.height / 2)
            let speed = 100.0
            let moveLeft = SKAction.moveBy(x: -element.size.width - element.size.width * CGFloat(number), y: 0, duration: TimeInterval(element.size.width + element.size.width * CGFloat(number)) / speed)
            let resetElement = SKAction.moveBy(x: size.width + element.size.width, y: 0, duration: 0)
            
            let fullScreenMove = SKAction.moveBy(x: -size.width - element.size.width, y: 0,
                                                 duration: TimeInterval(size.width + element.size.width) / speed)
            
            let elementMoveConstantly = SKAction.repeatForever(SKAction.sequence([fullScreenMove, resetElement]))
            element.run(SKAction.sequence([moveLeft, resetElement, elementMoveConstantly]))
        }
    }
    
    func startTimers() {
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createCoin()
        })
        
        birdTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.createBird()
        })
    }
    
    
    func gameOver() {
        
        scene?.isPaused = true  //Pause the scene
        
        //To Do:
        
        //1 - Stop the timers for coin and bird
        // Code required
       
        
        //2 - Update the Score label on the top-left of the screen
        yourScoreLabel = SKLabelNode(text: "Your Score:")
        //More Code required
       
        
         //3 - Update the final score on the screen
        finalScoreLabel = SKLabelNode(text: "\(score)")
        //More Code required
       
        //4 - Add the play button on the screen
        //This part is completed
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.position = CGPoint(x: 0, y: -200)
        playButton.name = "play"
        playButton.zPosition = 1
        addChild(playButton)
    }
    
    
  
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 100, height: 100)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.collisionBitMask = dummyCategory
        coin.physicsBody?.contactTestBitMask = marioCategory
        addChild(coin)
        
        let maxY = size.height / 2 - coin.size.height / 2
        let minY = -size.height / 2 + coin.size.height / 2
        let range = maxY - minY
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        coin.position = CGPoint(x: size.width / 2 + coin.size.width / 2, y: coinY)
        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width, y: 0, duration: 4)
        let mySeq = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        coin.run(mySeq)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
        }
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
        }
        
        if contact.bodyA.categoryBitMask == birdCategory {
            contact.bodyA.node?.removeFromParent()
            gameOver()
        }
        if contact.bodyB.categoryBitMask == birdCategory {
            contact.bodyB.node?.removeFromParent()
            gameOver()
        }
        
        
    }
    
  
}
