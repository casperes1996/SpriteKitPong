//
//  ViewController.swift
//  Pong
//
//  Created by Casper Sørensen on 16/06/2021.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = PongSKScene(size: NSScreen.main?.frame.size ?? CGSize(width: 1366, height: 768))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    override func viewWillAppear() {
        view.window?.toggleFullScreen(nil)

        
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.styleMask.remove(.fullScreen)
        self.view.window?.styleMask.remove(.closable)
        self.view.window?.styleMask.remove(.miniaturizable)
        self.view.window?.styleMask.remove(.resizable)
    }
}

