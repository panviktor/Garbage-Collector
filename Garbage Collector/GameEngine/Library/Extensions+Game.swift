import SpriteKit

extension SKScene {
    func removeUIViews(){
        for view in (view?.subviews)! {
            view.removeFromSuperview()
        }
    }
    
    func recursiveRemovingSKActions(sknodes:[SKNode]){
        for childNode in sknodes{
            childNode.removeAllActions()
            if childNode.children.count > 0 {
                recursiveRemovingSKActions(sknodes: childNode.children)
            }
        }
    }
}

extension SKLabelNode {
    func shadowNode(nodeName:String) -> SKEffectNode{
        let myShader = SKShader(fileNamed: "gradientMonoTone")
        let effectNode = SKEffectNode()
        effectNode.shader = myShader
        effectNode.shouldEnableEffects = true
        effectNode.addChild(self)
        effectNode.name = nodeName
        return effectNode
    }
}

/*RANDOM FUNCTIONS */
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}
