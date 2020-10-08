//
//  GameSettingsScene.swift
//
//  Created by Viktor on 14.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class GameSettingsScene: SKScene {
    private enum State {
        case Select
    }
    
    private enum GameSettingsSceneButton: String {
        case BackButton
        case VibroButton
        case MusicButton
    }
    
    private let settingsNode = SKSpriteNode()
    private var state: State = .Select
    private let screenSize: CGRect = UIScreen.main.bounds
    private let audioVibroManager = AudioManager.shared
    private let sceneManager = SceneManager.shared
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground()
        load()
    }
    
    private func loadBackground() {
        let loadBackground = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.gameSceneSettingsBackground))
        loadBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground.zPosition = -10
        self.addChild(loadBackground)
    }
    
    private func load(){
        // Title
        let title = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.gameSceneSettingsTitleLabel))
        title.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        title.position.y = screenSize.size.height / 3.5
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
        let backarrow = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.gameSceneSettingsBackButton))
        backarrow.name = GameSettingsSceneButton.BackButton.rawValue
        backarrow.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backarrow.position = CGPoint(x: -title.size.width/2 - 10, y: title.position.y + 3)
        backarrow.size = CGSize(width: screenSize.width / 6.5, height: screenSize.height * 0.1)
        self.addChild(backarrow)
        
        // settingsNode
        settingsNode.texture = SKTexture(imageNamed: ImageName.gameSceneSettingsNode)
        settingsNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        settingsNode.size = CGSize(width: screenSize.width / 1.25, height: screenSize.height / 3)
        settingsNode.alpha = 0.95
        settingsNode.zPosition = -9
        settingsNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -30, duration: 3),
                                                                   SKAction.moveBy(x: 0, y: 30, duration: 3),
        ])))
        
        //vibro button
        let vibroButton = SKSpriteNode(texture:  SKTexture(imageNamed: ImageName.gameSceneSettingsVibroButton))
        vibroButton.name = GameSettingsSceneButton.VibroButton.rawValue
        vibroButton.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        vibroButton.position.y = settingsNode.size.height / 6
        vibroButton.size = CGSize(width: settingsNode.size.width / 2.5, height: settingsNode.size.height / 2.75)
        vibroButton.zPosition = 5
        settingsNode.addChild(vibroButton)
        
        //sound button
        let musicButton = SKSpriteNode(texture:  SKTexture(imageNamed: ImageName.gameSceneSettingsMusicButton))
        musicButton.name = GameSettingsSceneButton.MusicButton.rawValue
        musicButton.anchorPoint = CGPoint(x: 0.5, y: 0.95)
        musicButton.size = CGSize(width: settingsNode.size.width / 2.5, height: settingsNode.size.height / 2.75)
        musicButton.zPosition = 5
        settingsNode.addChild(musicButton)
        
        self.addChild(settingsNode)
        try? audioVibroManager.playMusic(type: .mainSceneBackground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        
        switch state {
        case .Select:
            for c in nodes(at: pos){
                if c.name == GameSettingsSceneButton.BackButton.rawValue {
                    backButtonPressed()
                } else if c.name == GameSettingsSceneButton.VibroButton.rawValue {
                    audioVibroManager.vibroToggle()
                } else if c.name == GameSettingsSceneButton.MusicButton.rawValue {
                    audioVibroManager.musicToggle()
                }
            }
        }
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
