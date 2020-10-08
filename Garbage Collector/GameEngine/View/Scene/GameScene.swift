import SpriteKit
import AVFoundation
import DeviceKit

class GameScene: SKScene {
    private enum Scene {
        case MainScene
    }
    
    private enum MainSceneButton: String {
        case ExitButton
    }
    
    private var particles: SKEmitterNode?
    private var heroes: SKSpriteNode!
    private var prize: SKSpriteNode!
    private var woods: [SKSpriteNode]!
    private var level: Level!
    private let gameManager = GameManager.shared
    private var currentLevelNum: Int {
        get {
            gameManager.currentLevel
        }
    }
    private let screenSize: CGRect = UIScreen.main.bounds
    private let sceneManager = SceneManager.shared
    private var isLevelOver = false
    private var isLevelWin = false
    private var chapterIsOver = false
    private var didCutVine = false
    
    private let audioVibroManager = AudioManager.shared
    private let hapticManager = HapticManager()
    
    internal let device = Device.current
    
    override func didMove(to view: SKView) {
        setUpLevel(number: currentLevelNum)
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
    }
    
    //MARK: - Level setup
    private func setUpPhysics() {
        physicsWorld.contactDelegate = self
        //FIXME: - load from level
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
    }
    
    private func setUpScenery() {
        let background = SKSpriteNode(imageNamed: ImageName.background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layers.background
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
        
        let water = SKSpriteNode(imageNamed: ImageName.water)
        water.anchorPoint = CGPoint(x: 0, y: 0)
        water.position = CGPoint(x: 0, y: 0)
        water.zPosition = Layers.foreground
        water.size = CGSize(width: size.width, height: size.height * 0.2139)
        
        let emitter = SKEmitterNode(fileNamed: Emitter.rain)!
        emitter.zPosition = Layers.emitter
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        emitter.advanceSimulationTime(30)
        addChild(emitter)
        addChild(water)
    }
    
    private func setUpPrize() {
        prize = SKSpriteNode(imageNamed: ImageName.prize)
        prize.position = CGPoint(x: size.width * level.prizePosition.x,
                                 y: level.prizePosition.y)
        prize.zPosition = Layers.prize
        prize.size = CGSize(width: screenSize.width / 10, height: screenSize.width / 10)
        
        
        //FIXME: - desired texture masks for acceptable performance
        //   if device.isSimulator {
        //       prize.physicsBody = SKPhysicsBody(circleOfRadius: prize.size.height / 2)
        //   } else {
        //       prize.physicsBody = SKPhysicsBody(texture: prize.texture!, size: prize.size)
        //   }
        
        prize.physicsBody = SKPhysicsBody(circleOfRadius: prize.size.height / 2)
        prize.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.prize
        prize.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.wood
        prize.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.physicalObjectOne
        prize.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.physicalObjectTwo
        prize.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.physicalObjectThree
        prize.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.physicalObjectFour
        prize.physicsBody?.density = 0.25
        
        addChild(prize)
    }
    
    //MARK: - Vine methods
    private func setUpVines() {
        // load vine data
        let vines = level.vines
        for (i, vine) in vines.enumerated() {
            let anchorPoint = CGPoint(
                x: vine.xAnchorPoint * size.width,
                y: vine.yAnchorPoint * size.height)
            let vine = VineNode(length: vine.length, anchorPoint: anchorPoint, name: "VineNode_\(i)")
            
            vine.addToScene(self)
            vine.attachToPrize(prize)
        }
    }
    
    //MARK: - Items methods
    private func setUpWoods() {
        // load items data
        guard let items = level.items, !items.isEmpty else {
            return }
        for (_, item) in items.enumerated() {
            switch item.type {
            case .wood:
                let position = CGPoint(
                    x: item.xPoint * size.width,
                    y: item.yPoint * size.height)
                let rotation = item.zRotation ?? 360
                addWoodToScene(position, rotation)
            case .physicalObjectOne:
                let position = CGPoint(
                    x: item.xPoint * size.width,
                    y: item.yPoint * size.height)
                let rotation = item.zRotation ?? 360
                addObjectOneToScene(position, rotation)
            case .physicalObjectTwo:
                let position = CGPoint(
                    x: item.xPoint * size.width,
                    y: item.yPoint * size.height)
                let rotation = item.zRotation ?? 360
                addObjectTwoToScene(position, rotation)
            case .physicalObjectThree:
                let position = CGPoint(
                    x: item.xPoint * size.width,
                    y: item.yPoint * size.height)
                let rotation = item.zRotation ?? 360
                addObjectThreeToScene(position, rotation)
            case .physicalObjectFour:
                let position = CGPoint(
                    x: item.xPoint * size.width,
                    y: item.yPoint * size.height)
                let rotation = item.zRotation ?? 360
                addObjectFourToScene(position, rotation)
            default:
                print("ADD NEW ITEMS HANDLER")
            }
        }
    }
    
    //MARK: - Croc methods
    private func setUpCrocodile() {
        heroes = SKSpriteNode(imageNamed: ImageName.crocMouthClosed)
        
        if device.hasRoundedDisplayCorners {
            heroes.size = CGSize(width: screenSize.width / 5.5, height:  screenSize.height / 5)
        } else {
            heroes.size = CGSize(width: screenSize.width / 5.5, height:  screenSize.height / 4)
        }
        
        heroes.position = CGPoint(x: size.width * level.heroesPosition.x,
                                  y: size.height * level.heroesPosition.y)
        
        heroes.zPosition = Layers.crocodile
        
        if device.isSimulator {
            let sizeX = heroes.size.width * CGFloat(0.95)
            let sizeY = heroes.size.height * CGFloat(0.90)
            let newPhysicsBodySize = CGSize(width: sizeX, height: sizeY)
            heroes.physicsBody = SKPhysicsBody(rectangleOf: newPhysicsBodySize)
        } else {
            heroes.physicsBody = SKPhysicsBody(texture: heroes.texture!, size: heroes.size)
        }
        
        heroes.physicsBody!.categoryBitMask = PhysicsCategoryBitMask.crocodile
        heroes.physicsBody?.collisionBitMask = 0
        heroes.physicsBody?.contactTestBitMask = PhysicsCategoryBitMask.prize
        heroes.physicsBody?.isDynamic = false
        addChild(heroes)
        animateTheHero()
    }
    
    private func animateTheHero() {
        let duration = Double.random(in: 2...4)
        let open = SKAction.setTexture(SKTexture(imageNamed: ImageName.crocMouthOpen))
        let halfOpen = SKAction.setTexture(SKTexture(imageNamed: ImageName.crocMouthHalfOpen))
        let wait = SKAction.wait(forDuration: duration)
        let close = SKAction.setTexture(SKTexture(imageNamed: ImageName.crocMouthClosed))
        let sequence = SKAction.sequence([wait, open, wait, halfOpen, wait, close])
        heroes.run(.repeatForever(sequence))
    }
    
    private func runNomNomAnimation(withDelay delay: TimeInterval) {
        heroes.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.crocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.crocMouthOpen))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        
        heroes.run(sequence)
    }
    
    //MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didCutVine = false
        hapticManager?.startSwishPlayer()
        
        var pos: CGPoint!
        for touch in touches {
            pos = touch.location(in: self)
        }
        
        let childs = self.nodes(at: pos)
        for c in childs {
            if c.name == MainSceneButton.ExitButton.rawValue {
                hapticManager?.stopSwishPlayer()
                prepareToChangeScene(scene: .MainScene)
            } 
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            
            // check if vine cut
            scene?.physicsWorld.enumerateBodies(
                alongRayStart: startPoint,
                end: endPoint,
                using: { body, _, _, _ in
                    self.checkIfVineCut(withBody: body)
                })
            
            // produce some nice particles
            showMoveParticles(touchPosition: startPoint)
            
            let distance = CGVector(dx: abs(startPoint.x - endPoint.x), dy: abs(startPoint.y - endPoint.y))
            let distanceRatio = CGVector(dx: distance.dx / size.width, dy: distance.dy / size.height)
            let intensity = Float(max(distanceRatio.dx, distanceRatio.dy)) * 100
            hapticManager?.updateSwishPlayer(intensity: intensity)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        particles?.removeFromParent()
        particles = nil
        hapticManager?.stopSwishPlayer()
    }
    
    private func showMoveParticles(touchPosition: CGPoint) {
        if particles == nil {
            particles = SKEmitterNode(fileNamed: SceneParticles.particles)
            particles!.zPosition = 1
            particles!.targetNode = self
            addChild(particles!)
        }
        particles!.position = touchPosition
    }
    
    //MARK: - Game logic
    private func checkIfVineCut(withBody body: SKPhysicsBody) {
        if didCutVine && !GameConfiguration.canCutMultipleVinesAtOnce {
            return
        }
        
        let node = body.node!
        
        // if it has a name it must be a vine node
        if let name = node.name {
            if !name.contains("VineNode_") {
                return
            }
            // snip the vine
            node.removeFromParent()
            
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { node, _ in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
            
            if heroes != nil {
                heroes.removeAllActions()
                heroes.texture = SKTexture(imageNamed: ImageName.crocMouthOpen)
                animateTheHero()
            }
            
            if hapticManager != nil {
                hapticManager?.playSlice()
            } else {
                run(audioVibroManager.getAction(type: .slice))
            }
            didCutVine = true
        }
    }
    
    private func switchToNewGame(withTransition transition: SKTransition) {
        if currentLevelNum <= GameConfiguration.maximumLevel && isLevelOver && isLevelWin && !chapterIsOver {
            let delay = SKAction.wait(forDuration: 0.5)
            let sceneChange = SKAction.run {
                let transition = SKTransition.doorway(withDuration: 0.5)
                let winLevel = WinLevelScene(size: self.size)
                winLevel.scaleMode = .aspectFill
                print(#line, "New Level")
                self.view?.presentScene(winLevel, transition: transition)
            }
            run(.sequence([delay, sceneChange]))
        } else if currentLevelNum <= GameConfiguration.maximumLevel && !isLevelWin {
            let sceneChange = SKAction.run {
                self.recursiveRemovingSKActions(sknodes: self.children)
                self.removeAllChildren()
                self.removeAllActions()
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 0)
                print(#line, "Try Again")
                self.view?.presentScene(scene, transition: transition)
            }
            run(.sequence([sceneChange]))
        } else {
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
                self.recursiveRemovingSKActions(sknodes: self.children)
                self.removeAllChildren()
                self.removeAllActions()
                let scene = EndChapterScene(size: self.size)
                print(#line, "End Chapter")
                self.view?.presentScene(scene)
            }]))
        }
    }
    
    private func setUpLevel(number: Int) {
        var extraPoin: CGFloat = 0
        if Device.current.hasRoundedDisplayCorners {
            extraPoin = 25.0
        }
        
        let levelString = "Level_\(number)"
        level = Level.init(filename: levelString)
        let infobar = Infobar(name: "infobar")
        self.addChild(infobar)
        infobar.position.y = (screenSize.size.height) - infobar.mainRootHeight - extraPoin
        infobar.position.x = 0
        infobar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        infobar.zPosition = Layers.infobar
        infobar.updateLevelLabel(levelName: level.levelName)
        
        let exitButton = SKSpriteNode()
        exitButton.texture = SKTexture(imageNamed: ImageName.exitButton)
        exitButton.name = MainSceneButton.ExitButton.rawValue
        exitButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        exitButton.size = CGSize(width: 50, height: 50)
        exitButton.zPosition = Layers.exitButton
        exitButton.position = CGPoint(x: screenSize.width - exitButton.size.width - 15,
                                      y: screenSize.size.height - exitButton.size.height - infobar.size.height - extraPoin * 0.85 )
        exitButton.alpha = 0.25
        addChild(exitButton)
        
        setUpScenery()
        setUpPhysics()
        setUpPrize()
        setUpVines()
        delay(bySeconds: 0.8) {
            self.setUpCrocodile()
        }
        
        delay(bySeconds: 0.8) {
            self.setUpWoods()
        }
    }
    
    private func prepareToChangeScene(scene: Scene){
        switch scene {
        case .MainScene:
            backButtonPressed()
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
}

extension GameScene: SKPhysicsContactDelegate {
    override func update(_ currentTime: TimeInterval) {
        if isLevelOver {
            return
        }
        
        if prize.position.y <= 0 {
            isLevelOver = true
            if hapticManager != nil {
                hapticManager?.playSplash()
            } else {
                run(audioVibroManager.getAction(type: .splash))
            }
            switchToNewGame(withTransition: .fade(withDuration: 1.0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if isLevelOver {
            return
        }
        
        if (contact.bodyA.node == heroes && contact.bodyB.node == prize)
            || (contact.bodyA.node == prize && contact.bodyB.node == heroes) {
            
            isLevelOver = true
            isLevelWin = true
            
            if isLevelWin && currentLevelNum == GameConfiguration.maximumLevel {
                chapterIsOver = true
            }
            
            gameManager.addScore()
            gameManager.addLevel()
            
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([shrink, removeNode])
            prize.run(sequence)
            
            if hapticManager != nil {
                hapticManager?.playNomNom()
            } else {
                run(audioVibroManager.getAction(type: .nomNom))
            }
    
            runNomNomAnimation(withDelay: 0.15)
            switchToNewGame(withTransition: .doorway(withDuration: 1.0))
        }
    }
}
