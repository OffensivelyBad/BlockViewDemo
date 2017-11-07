//
//  GameScene.swift
//  BlockViewDemo
//
//  Created by Shawn Roller on 11/7/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var cameraIsZoomed = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupCamera()
        createBlocks(2000)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !self.cameraIsZoomed else { return }
        guard let touch = touches.first else { return }
        self.cameraIsZoomed = true
        zoomCameraInOnPoint(touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.cameraIsZoomed else { return }
        guard let touch = touches.first else { return }
        panCameraToPoint(touch.previousLocation(in: self), endPoint: touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.cameraIsZoomed else { return }
        self.cameraIsZoomed = false
        zoomCameraOut()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.cameraIsZoomed else { return }
        self.cameraIsZoomed = false
        zoomCameraOut()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// MARK: - Camera
extension GameScene {
    
    func setupCamera() {
        
        let camera = SKCameraNode()
        self.camera = camera
        guard let cam = self.camera else { return }
        self.addChild(cam)
        
    }
    
    func zoomCameraInOnPoint(_ point: CGPoint) {
        guard let cam = self.camera else { return }
        let scale = SKAction.scale(by: 0.25, duration: 0.25)
        let position = SKAction.move(to: point, duration: 0.25)
        cam.run(scale)
        cam.run(position)
    }
    
    func zoomCameraOut() {
        guard let cam = self.camera else { return }
        let scale = SKAction.scale(by: 4, duration: 0.25)
        let position = SKAction.move(to: CGPoint.zero, duration: 0.25)
        cam.run(scale)
        cam.run(position)
    }
    
    func panCameraToPoint(_ startPoint: CGPoint, endPoint: CGPoint) {
        guard let cam = self.camera else { return }
        let changeX = startPoint.x - endPoint.x
        let changeY = startPoint.y - endPoint.y
        cam.position.x += changeX
        cam.position.y += changeY
    }
    
}

// MARK: - UI Block Creation
extension GameScene {
    
    func createBlocks(_ qty: Int) {
        
        let blockSize = CGSize(width: 10, height: 10)
        let colors: [UIColor] = [.red, .yellow, .blue, .green, .gray, .white, .cyan, .purple, .magenta, .orange]
        let halfScreenWidth = self.size.width / 2
        let halfScreenHeight = self.size.height / 2
        
        var currentX = -halfScreenWidth + (blockSize.width / 2)
        var currentY = halfScreenHeight - (blockSize.height / 2)
        
        for i in 0..<qty {
            
            if currentX + blockSize.width > halfScreenWidth {
                currentY -= blockSize.height
                currentX = -halfScreenWidth + (blockSize.width / 2)
            }
            let color = colors[i % colors.count]
            let block = SKSpriteNode(color: color, size: blockSize)
            block.position = CGPoint(x: currentX, y: currentY)
            
            let labelNode = SKLabelNode(text: "\(i)")
            labelNode.fontSize = 4
            labelNode.position = CGPoint.zero
            block.addChild(labelNode)
            
            self.addChild(block)
            
            currentX += blockSize.width
        }
        
    }
    
}
