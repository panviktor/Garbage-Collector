//
//  WinLevelScene.swift

//  Created by Viktor on 14.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class WinLevelScene: SKScene {
    private let sceneManager = SceneManager.shared
    private let screenSize: CGRect = UIScreen.main.bounds
    var nextLevel: Int!
    override func didMove(to view: SKView) {
        loadBackground()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let transition = SKTransition.crossFade(withDuration: 1.0)
        guard let gameScene = sceneManager.gameScene else { return }

        gameScene.recursiveRemovingSKActions(sknodes: self.children)
        gameScene.removeAllChildren()
        gameScene.removeAllActions()
        
        let scene = GameScene(size: self.size)
        
        self.view?.presentScene(scene)
   
    }
    
    private func loadBackground() {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.winLevelSceneBackground))
        background.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        self.addChild(background)
    }
}


