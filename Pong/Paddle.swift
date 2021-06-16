//
//  Paddle.swift
//  Pong
//
//  Created by Casper Sørensen on 16/06/2021.
//

import Cocoa
import SpriteKit

class Paddle: SKShapeNode {
    var currentMovement = Direction.None
    var movementSpeed = CGFloat(1100)
    
    func move(screenHeight: CGFloat, deltaTime: CGFloat) -> Void {
        if(currentMovement == .Up && position.y <= (screenHeight/1.033 - frame.height/2)) {
            position.y += CGFloat(movementSpeed*deltaTime)
        } else if(currentMovement == .Down && position.y >= (screenHeight-(screenHeight/1.033) + frame.height/2)) {
            position.y -= CGFloat(movementSpeed*deltaTime)
        }
    }
}

enum Direction {
    case Up, Down, None
}
