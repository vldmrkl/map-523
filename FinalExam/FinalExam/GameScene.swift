//
//  GameScene.swift
//  FinalExam
//
//  Created by Volodymyr Klymenko on 2019-04-10.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ABCGate: SKSpriteNode?
    var DEFGate: SKSpriteNode?
    var GHIGate: SKSpriteNode?
    var recentCharacter: SKSpriteNode?
    
    var scoreLabel : SKLabelNode!
    var score: Int = 0

    var livesLabel : SKLabelNode!
    var lives: Int = 3

    var letterTimer: Timer?

    let characterCategory: UInt32 = 0x1 << 0
    let abcCategory: UInt32 = 0x1 << 1
    let defCategory: UInt32 = 0x1 << 2
    let ghiCategory: UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self


        ABCGate = childNode(withName: "ABCGate") as? SKSpriteNode
        ABCGate?.physicsBody?.categoryBitMask = abcCategory
        ABCGate?.physicsBody?.collisionBitMask = abcCategory
        ABCGate?.physicsBody?.contactTestBitMask = characterCategory

        DEFGate = childNode(withName: "DEFGate") as? SKSpriteNode
        DEFGate?.physicsBody?.categoryBitMask = defCategory
        DEFGate?.physicsBody?.collisionBitMask = defCategory
        DEFGate?.physicsBody?.contactTestBitMask = characterCategory

        GHIGate = childNode(withName: "GHIGate") as? SKSpriteNode
        GHIGate?.physicsBody?.categoryBitMask = ghiCategory
        GHIGate?.physicsBody?.collisionBitMask = ghiCategory
        GHIGate?.physicsBody?.contactTestBitMask = characterCategory

        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "Score: \(score)"

        livesLabel = childNode(withName: "livesLabel") as? SKLabelNode
        livesLabel.text = "❤️❤️❤️"

        letterTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.spawnCharacter()
        })

    }

    func spawnCharacter() {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        let randomCharacter = letters.randomElement()!
        let character = SKSpriteNode(imageNamed: randomCharacter)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        self.view!.addGestureRecognizer(swipeDown)

        character.size = CGSize(width: 75, height: 75)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)

        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.isDynamic = true

        character.physicsBody?.categoryBitMask = characterCategory
        character.physicsBody?.contactTestBitMask = abcCategory | defCategory | ghiCategory
        character.physicsBody?.collisionBitMask = characterCategory

        character.name = "\(randomCharacter.uppercased())characterNode"

        self.addChild(character)

        let minX = -size.width/2 + character.size.width
        let maxX = size.width/2 - character.size.width
        let range = maxX - minX
        let randomCharX = maxX - CGFloat(arc4random_uniform(UInt32(range)))

        character.position = CGPoint(x: randomCharX, y: size.height / 2 + character.size.height / 2)

        let flyDown = SKAction.moveBy(x: 0, y: -size.height - character.size.height, duration: 4)
        let moveCharacter = SKAction.sequence([flyDown, SKAction.removeFromParent()])

        character.run(moveCharacter)
        recentCharacter = character
    }

    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        let minX = -size.width/2 + recentCharacter!.size.width + 50
        let maxX = size.width/2 - recentCharacter!.size.width - 50

        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            let moveRight = SKAction.moveTo(x: maxX, duration: 1)
            recentCharacter!.run(moveRight)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            let moveLeft = SKAction.moveTo(x: minX, duration: 1)
            recentCharacter!.run(moveLeft)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            let moveDown = SKAction.moveTo(x: 0, duration: 1)
            recentCharacter!.run(moveDown)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var livesLeft = ""

        if contact.bodyB.categoryBitMask == characterCategory {
            let character = contact.bodyB.node?.name?.prefix(1)
            if ["A", "B", "C"].contains(character){
                if contact.bodyA.categoryBitMask == abcCategory {
                    score += 1
                } else{
                    print("Wrong gate")
                }
            } else if ["D", "E", "F"].contains(character) {
                if contact.bodyA.categoryBitMask == defCategory {
                    score += 1
                }
                else{
                    print("Wrong gate")
                }
            } else if ["G", "H", "I"].contains(character) {
                if contact.bodyA.categoryBitMask == ghiCategory {
                    score += 1
                } else{
                    print("Wrong gate")
                }
            }
        } else if contact.bodyA.categoryBitMask == characterCategory {
            let character = contact.bodyA.node?.name?.prefix(1)
            if ["A", "B", "C"].contains(character){
                if contact.bodyB.categoryBitMask == abcCategory {
                    score += 1
                } else{
                    print("Wrong gate")
                }
            } else if ["D", "E", "F"].contains(character) {
                if contact.bodyB.categoryBitMask == defCategory {
                    score += 1
                }
                else{
                    print("Wrong gate")
                }
            } else if ["G", "H", "I"].contains(character) {
                if contact.bodyB.categoryBitMask == ghiCategory {
                    score += 1
                } else{
                    print("Wrong gate")
                }
            }

        }

        if(lives > 0){
            for _ in 1...lives {
                livesLeft += "❤️"
            }
        }
        scoreLabel?.text = "Score: \(score)"
        livesLabel.text = livesLeft

    }
}
