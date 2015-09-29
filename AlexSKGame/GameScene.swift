//
//  GameScene.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/10/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import SpriteKit
import CoreMotion

/*
* Code Source:
* This game was inspired by a Space Invaders Tutorial by Riccardo D'Antoni, published on 10/29/14
* Found here: http://www.raywenderlich.com/76740/make-game-like-space-invaders-sprite-kit-and-swift-tutorial-part-1 
*
* In accordance with the Academic Honesty Guidelines at UChicago,
* I will specifically cite the instances where I utilized code written by Riccardo D'Antoni.
* These instances include the gravity/movement of the user-controlled Pikachu and the SKAction of
* the fired lightning bolt. Additionally, I organized my code in the same manner as the tutorial by
* demarking the UserInteraction and specific Sprite Helper methods.
* Please let me know if you have any questions!
*/



class GameScene: SKScene {
    
    var gameStarted = false
    var viewController:UIViewController?
    
    //Enemy size and quantity properties
    let enemySize = CGSize(width: 30,height: 30)
    let enemySpacing = CGSize(width: 20, height: 20)
    let enemyRowCount = 5
    let enemyColCount = 5
    
    //Names of Sprites
    let score = "score"
    let time = "time"
    let pikachuName = "pikachu"
    let lightningName = "lightning"
    let enemyName = "pokeball"
    let sparkName = "spark"
    
    //Two time intervals for use in punctuated updates
    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 3.0
    var timeOfLastMove2: CFTimeInterval = 0.0
    let labelDelay: CFTimeInterval = 1.0
    
    //Taps Queue - from Ray Wenderlich Tutorial
    var tapQueue: Array<Int> = []

    //Score and Time Remaining
    var pointScore = 0
    var timeScore = 60 //Set length of game in seconds
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    //Set background image, initiate Game and Accelerometer
    override func didMoveToView(view: SKView) {
        var bgImage = SKSpriteNode(imageNamed: "background.png")
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(bgImage)
        
        if(!self.gameStarted) {
            self.startGame()
            self.gameStarted = true
        }
        motionManager.startAccelerometerUpdates()
        userInteractionEnabled = true
        
    }
    
    //Calls three helper methods below to initiate the Pikachu, enemies, and score labels
    func startGame() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        makePikachu()
        setupEnemies()
        setupScore()
    }
    
    //MARK: Pikachu
    
    //Create a Pikachu sprite. Specify its physics properties
    func makePikachu() {
        let pikachu = SKSpriteNode(imageNamed: "pikasksprite.png")
        pikachu.name = pikachuName
        pikachu.position = CGPoint(x: self.size.width/2, y:40)
        pikachu.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: pikachu.frame.width+600, height: pikachu.frame.height))
        pikachu.physicsBody!.dynamic = true
        pikachu.physicsBody!.affectedByGravity = false
        pikachu.physicsBody!.mass = 0.05
        self.addChild(pikachu)
        
    }
    
    //MARK: Lightning
    
    //Helper to create the lightning bolt
    func makeLightning() -> SKSpriteNode! {
        var lightning: SKSpriteNode!
        lightning = SKSpriteNode(imageNamed: "lightningbolt@2x.png")
        lightning.name = lightningName
        
        return lightning
    }
    
    //Fire lightning by calling MakeLightning and specifying the start and end of the travel 
    // - Modified from Ray Wenderlich Tutorial
    func fireLightning() {
        //Check if there is an existing lightning. Only one lightning at a time is instituted to make gameplay more difficult.
        let existingLightning = self.childNodeWithName(lightningName)
        
        if existingLightning == nil {
            if let pikachu = self.childNodeWithName(pikachuName) {
                
                //If no lightning bolt, create it
                if let lightning = self.makeLightning() {
                    
                    //Get the position of pikachu
                    lightning.position = CGPoint(x: pikachu.position.x, y: pikachu.position.y + pikachu.frame.size.height - lightning.frame.size.height / 2)
                    
                    //Set the destination as the end of the screen vertically
                    let lightningDestination = CGPoint(x: pikachu.position.x, y: self.frame.size.height + lightning.frame.size.height / 2)
                    
                    //Set SKAction to travel from our set position to destination
                    let lightningAction = SKAction.sequence([SKAction.moveTo(lightningDestination, duration: 0.9), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
                    lightning.runAction(lightningAction)
                    
                    self.addChild(lightning)
                }
            }
        }
    }
    
    
    //MARK: Enemies
    
    //Helper to create an individual enemy. Name it based on row and column
    // - Modified from Ray Wenderlich Tutorial
    func makeEnemy(row: Int, col: Int) -> (SKSpriteNode) {
        let enemy = SKSpriteNode(imageNamed: "pokeball.png")
        enemy.size = enemySize
        let name = enemyName + String(row) + String(col)
        enemy.name = name
        return enemy
    }
    
    //Set up grid of enemies based on enemyColCount and enemyRowCount
    func setupEnemies() {
        let baseOrigin = CGPoint(x:size.width / 2.5, y: size.height/3)
        
        //For each element in row
        for var row = 1; row <= enemyRowCount; row++ {
            
            //Set enemy y position to be based on row and height and create a CG Point
            let enemyPositionY = CGFloat(row) * (enemySize.height * 2) + baseOrigin.y
            var enemyPosition = CGPoint(x:baseOrigin.x, y:enemyPositionY)
            
            //For each ement in column
            for var col = 1; col <= enemyColCount; col++ {
                //Call the helper method
                var enemy = makeEnemy(row, col: col)
                
                //Set the position based on calculated enemy position
                enemy.position = enemyPosition
                addChild(enemy)
                
                //For the next enemy, update the enemyPosition by adding the width and spacing
                enemyPosition = CGPoint(x: (enemyPosition.x + enemySize.width + enemySpacing.width), y: enemyPositionY)
            }
        }
    }
    
    
    //MARK: Display Info
    
    //Set the score Label text and position
    func setupScore() {
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.name = score
        scoreLabel.fontSize = 18
        scoreLabel.text = String(format: "Score: %d", pointScore)
        scoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (70 + scoreLabel.frame.size.height/2))
        
        let timeLabel = SKLabelNode(fontNamed: "Helvetica")
        timeLabel.name = time
        timeLabel.fontSize = 18
        timeLabel.text = String(format: "Time: %d", timeScore)
        timeLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (100 + scoreLabel.frame.size.height/2))
        
        addChild(scoreLabel)
        addChild(timeLabel)
    }
    
    //MARK: Touch Controls
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)  {
        
        if let touch = touches.first as? UITouch {
            self.tapQueue.append(1)
        }
    }
    
    //MARK: User Interactions
    
    // Translate the motion of the accelerometer into force applied to the user-controlled Pikachu
    //- From Ray Wenderlich Tutorial
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        let pikachu = childNodeWithName(pikachuName) as! SKSpriteNode
        
        if let data = motionManager.accelerometerData {
            if(fabs(data.acceleration.x) > 0.2) {
                pikachu.physicsBody!.applyForce(CGVectorMake(30.0 * CGFloat(data.acceleration.x), 0))
            }
        }
    }
    
    //Call the fireLightning method and remove the tap from queue
    func processUserTapsForUpdate(currentTime: CFTimeInterval) {
        for tapCount in self.tapQueue {
            if tapCount == 1 {
                self.fireLightning()
            }
            self.tapQueue.removeAtIndex(0)
        }
    }
    
    //Update the displayed pokeballs every time interval
    func activateEnemiesForUpdate(currentTime: CFTimeInterval)  {
        if (currentTime - timeOfLastMove < timePerMove) {
            return
        }
        
        //Unhide all pokeballs
        for var i = 1; i <= enemyRowCount ; ++i {
            for var j = 1; j <= enemyColCount ; ++j {
                var name = enemyName + String(i) + String(j)
                let selectedEnemy:SKNode = self.childNodeWithName(name)!
                selectedEnemy.hidden = false
            }
        }
        
        //Generate 6 random integers between 1 and 5
        let randRow = Int(arc4random_uniform(4))+1
        let randCol = Int(arc4random_uniform(4))+1
        
        let randRow2 = Int(arc4random_uniform(4))+1
        let randCol2 = Int(arc4random_uniform(4))+1
        
        let randRow3 = Int(arc4random_uniform(4))+1
        let randCol3 = Int(arc4random_uniform(4))+1
        
        //Set the hidden property to true for all pokeballs that do not have the randomly generated number's row and column value
        for var i = 1; i <= enemyRowCount ; ++i {
            for var j = 1; j <= enemyColCount ; ++j {
                if (i != randRow || j != randCol) && (i != randRow2 || j != randCol2) && (i != randRow3 || j != randCol3) {
                    var name = enemyName + String(i) + String(j)
                    let selectedEnemy:SKNode = self.childNodeWithName(name)!
                    selectedEnemy.hidden = true
                }
            }
        }
        
        timeOfLastMove = currentTime
    }
    
    //Hide enemies when they are hit and generate spark effects
    func processEnemiesHitForUpdate(currentTime: CFTimeInterval) {
        //If lightning exists on the field
        if let lightning:SKNode = self.childNodeWithName(lightningName) {
            
            //Loop through every enemy
            for var i = 1; i <= enemyRowCount ; ++i {
                for var j = 1; j <= enemyColCount ; ++j {
                    var name = enemyName + String(i) + String(j)
                    let selectedEnemy:SKNode = self.childNodeWithName(name)!
                    
                    //If the lightning is touching the enemy
                    if(selectedEnemy.containsPoint(lightning.position) && selectedEnemy.hidden == false ) {
                        
                        //Generate a SKEmitterNode at that point
                        let emitter : SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("SparkParticle", ofType: "sks")!)! as! SKEmitterNode
                        emitter.particlePosition = selectedEnemy.position
                        emitter.particleLifetime = 1
                        emitter.name = sparkName
                        self.addChild(emitter)
                        
                        //Increment the score, hide the enemy, and remove the lightning
                        pointScore++
                        selectedEnemy.hidden = true
                        lightning.removeFromParent()
                    }
                }
            }
        }
    }
    
    //Update the time and label
    func processScoreAndTimeChangeForUpdate(currentTime: CFTimeInterval) {
        if (currentTime - timeOfLastMove2 < labelDelay) {
            return
        }
        
        var scoreLabel = self.childNodeWithName(score) as! SKLabelNode
        var timeLabel = self.childNodeWithName(time) as! SKLabelNode
        
        scoreLabel.text = String(format: "Score: %d", pointScore)
        timeLabel.text = String(format: "Time: %d", timeScore--)
        
        //Remove any sparks that are present
        if let spark:SKNode = self.childNodeWithName(sparkName) {
            spark.removeFromParent()
        }
        
        //When time runs out, segue to the Game Over View Controller
        if timeScore == -1 {
            NSUserDefaults.standardUserDefaults().setInteger(pointScore, forKey: "score")
            self.viewController!.performSegueWithIdentifier("endGame", sender: viewController)
        }
        
        timeOfLastMove2 = currentTime
    }
    
    //MARK: Update
    
    //Update calls the predefined helper methods above
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        processUserMotionForUpdate(currentTime)
        processUserTapsForUpdate(currentTime)
        activateEnemiesForUpdate(currentTime)
        processEnemiesHitForUpdate(currentTime)
        processScoreAndTimeChangeForUpdate(currentTime)
    }
}
