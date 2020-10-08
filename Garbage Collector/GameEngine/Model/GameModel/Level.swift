import SpriteKit

struct Level {
    let levelName: String
    let levelNumber: Int
    let heroesPosition: CGPoint
    
    let vines: [Vine]
    let prizeType: PrizeType
    let prizePosition: CGPoint
    
    let items: [Item]?
    let bonusScore: Int?
    
    init?(filename: String) {
        guard let levelData = LevelData.loadFrom(file: filename) else {
            return nil
        }
        self.levelName = levelData.levelName
        self.levelNumber = levelData.levelNumber
        self.heroesPosition = levelData.heroesPosition.position
        self.vines = levelData.vines
        
        switch levelData.prizeType {
        case 1:
            self.prizeType = .common
        case 2:
            self.prizeType = .rare
        case 3:
            self.prizeType = .unique
        default:
            self.prizeType = .common
        }
        
        self.prizePosition = levelData.prizePosition.position
        self.items = levelData.items
        self.bonusScore = levelData.bonusScore
    }
}
