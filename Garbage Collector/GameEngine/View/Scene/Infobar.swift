import SpriteKit

//FIXME: - not working yet

class Infobar: SKSpriteNode {
    private enum Template {
        case First // Display Level?
        case Second // Display Money?
    }
    
    private let screenSize: CGRect = UIScreen.main.bounds
    private let mainRootWidth: CGFloat = UIScreen.main.bounds.width
    let mainRootHeight: CGFloat = 50
    private var firstTemplate: SKSpriteNode!
    private var secondTemplate: SKSpriteNode!
    
    convenience init(name n: String) {
        self.init()
        let rootItemSize = CGSize(width: screenSize.width / 2.2,
                                  height: screenSize.height * 0.05)
        name = n
        color = .clear
        size = CGSize(width: mainRootWidth, height: mainRootHeight)
        
        // Main_Menu_Currency_Bar
        firstTemplate = generateTemplate(templateStyle: .First, itemSize: rootItemSize,
                                         name: "topbar_first_item",  previousPos: nil)
        secondTemplate = generateTemplate(templateStyle: .Second, itemSize: rootItemSize,
                                          name: "topbar_second_item",  previousPos: firstTemplate.position)
        
        self.addChild(firstTemplate)
        self.addChild(secondTemplate)
    }
    
    private func generateTemplate(templateStyle: Template,
                                  itemSize: CGSize, name n: String,
                                  previousPos prev: CGPoint?) -> SKSpriteNode {
        
        var positionX: CGFloat!
        let (w, h) = (itemSize.width, itemSize.height)
        
        positionX = (prev == nil) ? 0.0 + 10 : prev!.x + w + 10
        
        let node = SKSpriteNode()
        node.color = .clear
        node.name = n
        node.size = CGSize(width: w, height: h)
        node.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        node.position = CGPoint(x: positionX, y: h / 2)
        
        
        switch templateStyle {
        case .First:
            var secondHeartPositionX: CGFloat!
            var thirdHeartPositionX: CGFloat!
            
            let firstHeart = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
            firstHeart.name = "firstHeart"
            firstHeart.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            firstHeart.position = CGPoint(x: 10, y: node.position.y / 2)
            firstHeart.size = CGSize(width: node.size.width / 6, height: node.size.height / 2)
            node.addChild(firstHeart)
            
            secondHeartPositionX = firstHeart.size.width + firstHeart.position.x + 5
            
            let secondHeart = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
            secondHeart.name = "secondHeart"
            secondHeart.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            secondHeart.position = CGPoint(x: secondHeartPositionX, y: node.position.y / 2)
            secondHeart.size = CGSize(width: node.size.width / 6, height: node.size.height / 2)
            node.addChild(secondHeart)
            
            thirdHeartPositionX = firstHeart.size.width + secondHeart.position.x + 5
            let thirdHeart = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
            thirdHeart.name = "thirdHeart"
            thirdHeart.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            thirdHeart.position = CGPoint(x: thirdHeartPositionX, y: node.position.y / 2)
            thirdHeart.size = CGSize(width: node.size.width / 6, height: node.size.height / 2)
            
            //FIXME: - Remove: node.alpha = 0
            node.alpha = 0.75
            node.addChild(thirdHeart)
            
        case .Second:
            let labelText = SKLabelNode(fontNamed: "KohinoorTelugu-Medium")
            labelText.text = "Level Name First"
            labelText.fontSize = 30
            labelText.fontColor = SKColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            labelText.horizontalAlignmentMode = .center
            labelText.verticalAlignmentMode = .center
            labelText.position = CGPoint(x: node.position.x / 2, y: node.position.y / 2)
            labelText.name = "levelText"
            node.addChild(labelText.shadowNode(nodeName: "LevelLabelName"))
        }
        return node
    }
    
    func fadeAway() {
        let fadeAwayAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
        firstTemplate.run(fadeAwayAction)
        secondTemplate.run(fadeAwayAction)
    }
    
    func updateHeartLabel(hertCount: Int, fadeAway: Bool) {
        var heartNumber: String!
        switch hertCount {
        case 1:
            heartNumber = "firstHeart"
        case 2:
            heartNumber = "secondHeart"
        case 3:
            heartNumber = "thirdHeart"
        default:
            break
        }
        
        guard let heartLabel = firstTemplate.childNode(withName: heartNumber) as? SKSpriteNode else {
            print ("ERROR A01: Check updateHeartLabel method from Class Infobar")
            return
        }
        
        fadeAway == true ? heartLabel.run(SKAction.fadeAlpha(to: 0, duration: 0.2)) : heartLabel.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
    
    func updateLevelLabel(levelName: String) {
        guard let coinShadowLabel = secondTemplate.childNode(withName: "LevelLabelName") as? SKEffectNode else {
            print ("ERROR A01: Check updateLevelLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "levelText") as? SKLabelNode else{
            print ("ERROR A02: Check updateLevelLabel method from Class Infobar")
            return
        }
        
        coinLabel.text = levelName
    }
}

