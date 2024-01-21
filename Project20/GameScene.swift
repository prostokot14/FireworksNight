//
//  GameScene.swift
//  Project20
//
//  Created by Антон Кашников on 21/01/2024.
//

import SpriteKit

final class GameScene: SKScene {
    
    // MARK: - Private Properties
    
    private var gameTimer: Timer?
    private var fireworks = [SKNode]()
    private var score = 0 {
        didSet {
            
        }
    }
    
    private let leftEdge = -22
    private let bottomEdge = -22
    private let rightEdge = 1024 + 22
    
    // MARK: - SKScene
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    // MARK: - Private Methods
    
    private func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // Create the firework container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // Create the firework
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 // recolor sprites dynamically with absolutely no performance cost
        firework.name = "firework"
        node.addChild(firework)
        
        // Give the firework sprite node one of three random colors
        firework.color = switch Int.random(in: 0...2) {
        case 0: .cyan
        case 1: .green
        case 2: .red
        default: .white
        }
        
        // Create a UIBezierPath that will represent the movement of the firework
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // Tell the container node to follow that path, turning itself as needed
        node.run(SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200))
        
        // Create particles behind the rocket to make it look like the fireworks are lit
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // Add the firework to fireworks array and also to the scene
        fireworks.append(node)
        addChild(node)
    }
    
    private func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let nodesAtPoint = nodes(at: touch.location(in: self))
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    @objc
    private func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // straight up
            var x = 512 - 200
            for _ in 1...5 {
                createFirework(xMovement: 0, x: x, y: bottomEdge)
                x += 100
            }
        case 1:
            // in a fan
            var delta = -200
            for _ in 1...5 {
                createFirework(xMovement: CGFloat(delta), x: 512 + delta, y: bottomEdge)
                delta += 100
            }
        case 2:
            // from the left to the right
            var delta = 400
            for _ in 1...5 {
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + delta)
                delta -= 100
            }
        case 3:
            // from the right to the left
            var delta = 400
            for _ in 1...5 {
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + delta)
                delta -= 100
            }
        default: break
        }
    }
}
