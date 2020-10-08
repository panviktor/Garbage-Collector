//
//  WoodNode.swift
//
//  Created by Виктор on 26.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

extension GameScene {
    func addWoodToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let wood = SKSpriteNode(imageNamed: ImageName.woodTexture)
        wood.size = CGSize(width: 100, height: 11)
        wood.position = CGPoint(x: position.x, y: position.y)
        wood.zRotation = .pi / rotation
        wood.zPosition = Layers.wood
        wood.physicsBody = SKPhysicsBody(texture:  SKTexture(imageNamed: ImageName.woodTexture), size: wood.size)
        wood.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.wood
        wood.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        wood.physicsBody?.restitution = 0.75
        wood.physicsBody?.isDynamic = false
        
        addChild(wood)
    }
    
    func addObjectOneToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let object = SKSpriteNode(imageNamed: ImageName.physicalObjectOneTexture)
        object.size = CGSize(width: 55, height: 55)
        object.position = CGPoint(x: position.x, y: position.y)
        object.zRotation = .pi / rotation
        object.zPosition = Layers.physicalObjectOne
        
        if device.isSimulator {
            let sizeX = object.size.width * CGFloat(0.95)
            let sizeY = object.size.height * CGFloat(0.95)
            let newPhysicsBodySize = CGSize(width: sizeX, height: sizeY)
            object.physicsBody = SKPhysicsBody(rectangleOf: newPhysicsBodySize)
        } else {
            object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        }
        
        object.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.physicalObjectOne
        object.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        object.physicsBody?.restitution = 0.8
        object.physicsBody?.isDynamic = false
        print(#line, #function)
        addChild(object)
    }
    
    func addObjectTwoToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let object = SKSpriteNode(imageNamed: ImageName.physicalObjectTwoTexture)
        object.size = CGSize(width: 55, height: 55)
        object.position = CGPoint(x: position.x, y: position.y)
        object.zRotation = .pi / rotation
        object.zPosition = Layers.physicalObjectTwo
        
        if device.isSimulator {
            let sizeX = object.size.width * CGFloat(0.95)
            let sizeY = object.size.height * CGFloat(0.95)
            let newPhysicsBodySize = CGSize(width: sizeX, height: sizeY)
            object.physicsBody = SKPhysicsBody(rectangleOf: newPhysicsBodySize)
        } else {
            object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        }
        
        object.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.physicalObjectTwo
        object.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        object.physicsBody?.restitution = 0.75
        object.physicsBody?.isDynamic = false
        print(#line, #function)
        addChild(object)
    }
    
    func addObjectThreeToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let object = SKSpriteNode(imageNamed: ImageName.physicalObjectThreeTexture)
        object.size = CGSize(width: 55, height: 55)
        object.position = CGPoint(x: position.x, y: position.y)
        object.zRotation = .pi / rotation
        object.zPosition = Layers.physicalObjectTree
        
        if device.isSimulator {
            let sizeX = object.size.width * CGFloat(0.95)
            let sizeY = object.size.height * CGFloat(0.95)
            let newPhysicsBodySize = CGSize(width: sizeX, height: sizeY)
            object.physicsBody = SKPhysicsBody(rectangleOf: newPhysicsBodySize)
        } else {
            object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        }
        
        object.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.physicalObjectThree
        object.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        object.physicsBody?.restitution = 0.7
        object.physicsBody?.isDynamic = false
        print(#line, #function)
        addChild(object)
    }
    
    func addObjectFourToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let object = SKSpriteNode(imageNamed: ImageName.physicalObjectFourTexture)
        object.size = CGSize(width: 55, height: 55)
        object.position = CGPoint(x: position.x, y: position.y)
        object.zRotation = .pi / rotation
        object.zPosition = Layers.physicalObjectFour
        
        if device.isSimulator {
            let sizeX = object.size.width * CGFloat(0.95)
            let sizeY = object.size.height * CGFloat(0.95)
            let newPhysicsBodySize = CGSize(width: sizeX, height: sizeY)
            object.physicsBody = SKPhysicsBody(rectangleOf: newPhysicsBodySize)
        } else {
            object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        }
        
        object.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.physicalObjectFour
        object.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        object.physicsBody?.restitution = 0.5
        object.physicsBody?.isDynamic = false
        print(#line, #function)
        addChild(object)
    }
}

