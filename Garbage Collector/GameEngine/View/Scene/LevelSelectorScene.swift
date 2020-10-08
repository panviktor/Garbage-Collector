//
//  LevelSelectorScene.swift
//
//  Created by Viktor on 18.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class LevelSelectorScene: SKScene {
    private enum State {
        case Select
    }
    
    private enum LevelSelectorSceneButton: String {
        case BackButton
    }
    
    private let settingsNode = SKSpriteNode()
    private var state: State = .Select
    private let screenSize: CGRect = UIScreen.main.bounds
    private let audioVibroManager = AudioManager.shared
    private let sceneManager = SceneManager.shared
   
    private var gameTableView = GameLevelTableView()
    private var label: SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground()
        load()
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame = CGRect(x: screenSize.width * 0.01,  y:  screenSize.height * 0.25, width: screenSize.width * 0.98, height: screenSize.height * 0.65)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        
        switch state {
        case .Select:
            for c in nodes(at: pos){
                if c.name == LevelSelectorSceneButton.BackButton.rawValue {
                    backButtonPressed()
                }
            }
        }
    }
    
    private func loadBackground() {
        let loadBackground = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.levelSelectorSceneBackground))
        loadBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground.zPosition = -10
        self.addChild(loadBackground)
    }
    
    private func load(){
        // Title
        let title = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.levelSelectorSceneTitleLabel))
        title.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        title.position.y = screenSize.size.height / 3
        title.zPosition = -8
        title.size = CGSize(width: screenSize.width * 0.6, height: screenSize.height * 0.12)
        title.alpha = 0.95
        title.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -30, duration: 1),
                                                            SKAction.scale(to: 1.5, duration: 1),
                                                            SKAction.moveBy(x: 0, y: 30, duration: 1),
                                                            SKAction.scale(to: 0.9, duration: 1)
           ])))
        self.addChild(title)
        
        // BackArrow
        let backarrow = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.levelSelectorSceneBackButton))
        backarrow.name = LevelSelectorSceneButton.BackButton.rawValue
        backarrow.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backarrow.position = CGPoint(x: -title.size.width/2 - 10, y: title.position.y + 3)
        backarrow.size = CGSize(width: screenSize.width / 6.5, height: screenSize.height * 0.1)
        self.addChild(backarrow)
        try? audioVibroManager.playMusic(type: .mainSceneBackground)
    }
    
    private func backButtonPressed(){
        self.recursiveRemovingSKActions(sknodes: self.children)
        self.removeAllChildren()
        self.removeAllActions()
        sceneManager.mainScene = nil
        let newScene = MainScene(size: self.size)
        self.view?.presentScene(newScene)
    }
}
