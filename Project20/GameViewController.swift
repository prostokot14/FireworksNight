//
//  GameViewController.swift
//  Project20
//
//  Created by Антон Кашников on 21/01/2024.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .fill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone { .allButUpsideDown } else { .all }
    }

    override var prefersStatusBarHidden: Bool { true }
}
