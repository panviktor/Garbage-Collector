//
//  TopScoreScene.swift
//
//  Created by Viktor on 14.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class TopScoreScene: SKScene {
    private enum State {
        case Select
    }
    
    private enum TopScoreSceneButton: String {
        case BackButton
        case ResetButton
    }
    
    private var scoreNode = SKSpriteNode()
    private var state: State = .Select
    private let sceneManager = SceneManager.shared
    private let audioVibroManager = AudioManager.shared
    private let gameManager = GameManager.shared
    private let screenSize: CGRect = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground()
        load()
    }
    
    private func loadBackground() {
        let loadBackground = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.topScoreSceneBackground))
        loadBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground.zPosition = -10
        self.addChild(loadBackground)
    }
    
    private func load() {
        // Title
        let title = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.topScoreSceneTitleLabel))
        title.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        title.position.y = screenSize.size.height / 3.5
        title.zPosition = -8
        title.size = CGSize(width: screenSize.width * 0.6, height: screenSize.height * 0.12)
        title.alpha = 0.95
        title.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -20, duration: 0.1),
                                                            SKAction.scale(to: 1.5, duration: 0.5),
                                                            SKAction.moveBy(x: 0, y: 20, duration: 1),
                                                            SKAction.scale(to: 1.9, duration: 1.5)
        ])))
        self.addChild(title)
        
        // BackArrow
        let backarrow = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.topScoreSceneBackButton))
        backarrow.name = TopScoreSceneButton.BackButton.rawValue
        backarrow.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backarrow.position = CGPoint(x: -title.size.width/2 - 10, y: title.position.y + 3)
        backarrow.size = CGSize(width: screenSize.width / 6.5, height: screenSize.height * 0.1)
        self.addChild(backarrow)
        
        // scoreNode
        scoreNode.texture = SKTexture(imageNamed: ImageName.topScoreSceneNode)
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreNode.size = CGSize(width: screenSize.width/1.1, height: screenSize.height / 3)
        scoreNode.alpha = 0.95
        scoreNode.zPosition = -9
        scoreNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 1),
                                                                SKAction.moveBy(x: 0, y: -20, duration: 1.2)])))
        self.addChild(scoreNode)
        
        
        let firstTextLine = SKLabelNode(fontNamed: "KohinoorTelugu-Medium")
        firstTextLine.text = "Completed \(gameManager.currentLevel) of \(GameConfiguration.maximumLevel) levels"
        firstTextLine.fontSize = screenSize.width / 15
        firstTextLine.fontColor = SKColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        firstTextLine.horizontalAlignmentMode = .center
        firstTextLine.verticalAlignmentMode = .center
        firstTextLine.position = CGPoint(x: scoreNode.position.x / 2,
                                         y: scoreNode.size.height / 2 - firstTextLine.fontSize * 2 )
        firstTextLine.name = "firstTextLine"
        firstTextLine.zPosition = 15
        scoreNode.addChild(firstTextLine)
        
        let secondTextLine = SKLabelNode(fontNamed: "KohinoorTelugu-Medium")
        secondTextLine.text = "Collected \(gameManager.currentScore) points."
        secondTextLine.fontSize = screenSize.width / 15
        secondTextLine.fontColor = SKColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        secondTextLine.horizontalAlignmentMode = .center
        secondTextLine.verticalAlignmentMode = .center
        secondTextLine.position = CGPoint(x: scoreNode.position.x / 2,
                                          y: firstTextLine.position.y - secondTextLine.fontSize * 2 )
        secondTextLine.name = "secondTextLine"
        secondTextLine.zPosition = 15
        scoreNode.addChild(secondTextLine)
        
        let thirdTextLine = SKLabelNode(fontNamed: "KohinoorTelugu-Medium")
        thirdTextLine.text = "Reset your progress?"
        thirdTextLine.fontSize = screenSize.width / 13
        thirdTextLine.fontColor = SKColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        thirdTextLine.horizontalAlignmentMode = .center
        thirdTextLine.verticalAlignmentMode = .center
        thirdTextLine.position = CGPoint(x: scoreNode.position.x / 2,
                                         y: secondTextLine.position.y - secondTextLine.fontSize * 2 )
        thirdTextLine.name = "thirdTextLine"
        thirdTextLine.zPosition = 15
        scoreNode.addChild(thirdTextLine)
        
        let resetButton = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.topScoreResetButton))
        resetButton.name = TopScoreSceneButton.ResetButton.rawValue
        resetButton.position = CGPoint(x: scoreNode.position.x / 2,
                                                y: thirdTextLine.position.y - secondTextLine.fontSize * 2)
        resetButton.size = CGSize(width: scoreNode.size.width / 4.5, height: scoreNode.size.height / 4.5)
        resetButton.zPosition = 15
        scoreNode.addChild(resetButton)
        
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
                if c.name ==  TopScoreSceneButton.BackButton.rawValue {
                    backButtonPressed()
                } else if c.name == TopScoreSceneButton.ResetButton.rawValue {
                    resetGame()
                }
            }
        }
    }
    
    private func backButtonPressed() {
        self.recursiveRemovingSKActions(sknodes: self.children)
        self.removeAllChildren()
        self.removeAllActions()
        sceneManager.mainScene = nil
        let newScene = MainScene(size: self.size)
        self.view?.presentScene(newScene)
    }
    
    private func resetGame() {
        gameManager.resetAll()
        backButtonPressed()
    }
}
