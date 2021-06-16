//
//  GameScene.swift
//  Pong
//
//  Created by Casper Sørensen on 16/06/2021.
//

import SpriteKit
import GameplayKit
import AVKit

class PongSKScene: SKScene {
    
    var lastUpdatedTime = TimeInterval(0)
    
    lazy var hitDelegat = BallHit(scene: self)
            
    func invSqrt(x: Float) -> Float {
        let halfx = 0.5 * x
        var i = x.bitPattern
        i = 0x5f3759df - (i >> 1)
        var y = Float(bitPattern: i)
        y = y * (1.5 - (halfx * y * y))
        return y
    }

    
    let screenWidth = NSScreen.main!.frame.width
    let screenHeight = NSScreen.main!.frame.height
    
    lazy var leftPaddle = Paddle(rectOf: CGSize(width: screenWidth/55, height: screenHeight/5))
    lazy var rightPaddle = Paddle(rectOf: CGSize(width: screenWidth/55, height: screenHeight/5))
    lazy var leftScore = SKLabelNode(text: "0")
    lazy var rightScore = SKLabelNode(text: "0")
    lazy var ball = SKShapeNode(circleOfRadius: screenWidth/screenHeight*15)
    var gameRunning = false
    
    fileprivate func preparePaddles() {
        anchorPoint = CGPoint(x: 0, y: 0)
        leftPaddle.position.x = leftPaddle.frame.width*3
        leftPaddle.position.y = screenHeight/2
        leftPaddle.fillColor = .white
        leftPaddle.physicsBody = SKPhysicsBody(rectangleOf: leftPaddle.frame.size)
        leftPaddle.physicsBody?.affectedByGravity = false
        leftPaddle.physicsBody?.categoryBitMask = 1
        leftPaddle.physicsBody?.isDynamic = false
        rightPaddle.position.x = screenWidth - (rightPaddle.frame.width*3)
        rightPaddle.position.y = screenHeight/2
        rightPaddle.fillColor = .white
        rightPaddle.physicsBody = SKPhysicsBody(rectangleOf: rightPaddle.frame.size)
        rightPaddle.physicsBody?.affectedByGravity = false
        rightPaddle.physicsBody?.categoryBitMask = 1
        rightPaddle.physicsBody?.isDynamic = false
        addChild(leftPaddle)
        addChild(rightPaddle)
    }
    
    fileprivate func placeScores() -> Void {
        leftScore.position.x = screenWidth/4
        leftScore.position.y = screenHeight/1.1
        leftScore.fontSize = screenWidth/screenHeight*50
        rightScore.position.x = screenWidth/4*3
        rightScore.position.y = screenHeight/1.1
        rightScore.fontSize = screenWidth/screenHeight*50
        addChild(leftScore)
        addChild(rightScore)
    }
    
    fileprivate func addDivider() -> Void {
        let divider = SKShapeNode(rectOf: CGSize(width: screenWidth/1600, height: screenHeight))
        divider.position.x = screenWidth/2
        divider.position.y = screenHeight/2
        divider.zPosition = -100
        divider.fillColor = .gray
        divider.strokeColor = .gray
        addChild(divider)
    }
    
    fileprivate func startCountdown() {
        if(gameRunning) { return }
        gameRunning = true
        let timeLeft = SKLabelNode(text: "5")
        timeLeft.fontSize = screenWidth/screenHeight*200
        timeLeft.fontName = "Arial Bold"
        timeLeft.fontColor = .init(srgbRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        timeLeft.position.y = screenHeight/2
        timeLeft.position.x = screenWidth/2
        addChild(timeLeft)
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.7), repeats: true) { timer in
            var i = Int(timeLeft.text!)!
            if(i > 1) {
                i -= 1
                timeLeft.text = String(i)
            } else {
                timeLeft.removeFromParent()
                timer.invalidate()
                self.startGame()
            }
        }
    }
    
    fileprivate func setUpBall() -> Void {
        ball.physicsBody = SKPhysicsBody.init(circleOfRadius: ball.frame.width/2)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.restitution = 1.0;
        ball.physicsBody?.linearDamping = 0.0;
        ball.physicsBody?.angularDamping = 0.0;
        ball.physicsBody?.contactTestBitMask = 1
    }
    
    fileprivate func startGame() -> Void {
        let dx2 = Float.random(in: -100...100)
        let dy2 = Float.random(in: -100...100)
        let mag2 = pow(dx2,2) + pow(dy2,2)
        let dx = invSqrt(x: mag2) * dx2 * 100
        let dy = invSqrt(x: mag2) * dy2 * 100
        if((dx > 0 && dx < 35) || (dx < 0 && dx > -35)) {
            return startGame()
        }
        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(dx), dy: CGFloat(dy)))
    }
    
    fileprivate func makeCourt() -> Void {
        self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: NSScreen.main!.frame)
        self.physicsBody!.categoryBitMask = 1
    }
    
    override func didMove(to view: SKView) {
        preparePaddles()
        setUpBall()
        ball.position.x = screenWidth/2
        ball.position.y = screenHeight/2
        ball.fillColor = .white
        addChild(ball)
        addDivider()
        placeScores()
        makeCourt()
        physicsWorld.contactDelegate = hitDelegat
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 49: //Spacebar
            startCountdown()
        case 126: // Arrow up
            rightPaddle.currentMovement = .Up
        case 125: // Arrow down
            rightPaddle.currentMovement = .Down
        case 13: // w
            leftPaddle.currentMovement = .Up
        case 1:  // s
            leftPaddle.currentMovement = .Down
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 126, 125: // Up and Down Arrows
            rightPaddle.currentMovement = .None
        case 13, 1: // W and S keys
            leftPaddle.currentMovement = .None
        default:
            return
        }
    }
    
    fileprivate func movePaddles(deltaTime: TimeInterval) -> Void {
        rightPaddle.move(screenHeight: screenHeight, deltaTime: CGFloat(deltaTime))
        leftPaddle.move(screenHeight: screenHeight, deltaTime: CGFloat(deltaTime))
    }
    
    fileprivate func checkForDeath() -> Void {
        if(ball.position.x - ball.frame.width > rightPaddle.position.x) {
            score(.right)
        } else if(ball.position.x + ball.frame.width < leftPaddle.position.x) {
            score(.left)
        }
    }
    
    fileprivate func score(_ player: Player) {
        isPaused = true
        if(player == .left) {
            rightScore.text = String(Int(rightScore.text!)! + 1)
        } else if(player == .right) {
            leftScore.text = String(Int(leftScore.text!)! + 1)
        }
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1.5), repeats: false, block: { t in
            self.ball.position = CGPoint(x: self.screenWidth/2, y: self.screenHeight/2)
            self.ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.gameRunning = false
            self.isPaused = false
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(lastUpdatedTime == 0) {
            lastUpdatedTime = currentTime
        }
        let deltaTime = currentTime-lastUpdatedTime
        movePaddles(deltaTime: deltaTime)
        checkForDeath()
        self.lastUpdatedTime = currentTime
    }
}

enum Player {
    case right, left
}
