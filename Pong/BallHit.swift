//
//  BallHit.swift
//  Pong
//
//  Created by Casper Sørensen on 16/06/2021.
//

import Cocoa
import SpriteKit

class BallHit:  NSObject, SKPhysicsContactDelegate {
    
    
    var scene: PongSKScene
    
    let playPong = SKAction.playSoundFileNamed("Pong.m4a", waitForCompletion: false)
    
    init(scene: PongSKScene) {
        self.scene = scene
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        let object1 = contact.bodyA.node
        let object2 = contact.bodyB.node
                
        if object1 == scene.ball || object2 == scene.ball {
            
            //play the sound
            scene.ball.run(playPong)
            
        }
    }
}
