import CoreGraphics

enum ImageName {
    ///Main Scene Textures
    static let mainSceneBackground = "MainSceneBackground"
    static let mainSceneCloud = "MainSceneCloud"
    static let mainScenePlayButton = "MainScenePlayButton"
    static let mainSceneLevelButton = "MainSceneLevelButton"
    static let mainSceneSettingsButton = "MainSceneSettingsButton"
    static let mainSceneChoosePresentButton = "MainSceneChoosePriseButton"
    static let mainSceneScoreButton = "MainSceneScoreButton"
    
    /// Game Scene Textures
    static let background = "Background"
    static let ground = "Ground"
    static let water = "Water"
    static let vineTexture = "VineTexture"
    static let vineHolder = "VineHolder"
    static let crocMouthClosed = "CrocMouthClosed"
    static let crocMouthHalfOpen = "CrocMouthHalfOpen"
    static let crocMouthOpen = "CrocMouthOpen"
    static let heroesMask = "CrocMask"
    static let prize = "MainPrize"
    static let prizeMask = "MainPrizeMask"
    static let woodTexture = "Wood"
    
    static let physicalObjectOneTexture = "PhysicalObjectOneTexture"
    static let physicalObjectTwoTexture = "PhysicalObjectTwoTexture"
    static let physicalObjectThreeTexture = "PhysicalObjectThreeTexture"
    static let physicalObjectFourTexture = "PhysicalObjectFourTexture"
    
    static let exitButton = "ExitButton"
    
    /// End Chapter Scene Textures
    static let endChapterSceneBackground = "EndChapterSceneBackground"
    
    /// Win Level Scene Texture
    static let winLevelSceneBackground = "WinLevelSceneBackground"
    
    /// Level Selector Scene Texture
    static let levelSelectorSceneBackground = "LevelSelectorSceneBackground"
    static let levelSelectorSceneTitleLabel = "LevelSelectorSceneTitleLabel"
    static let levelSelectorSceneBackButton = "LevelSelectorSceneBackButton"
    
    /// Game Settings Scene Texture
    static let gameSceneSettingsBackground = "GameSceneSettingBackground"
    static let gameSceneSettingsTitleLabel = "GameSceneSettingsTitleLabel"
    static let gameSceneSettingsNode = "GameSceneSettingsNode"
    static let gameSceneSettingsBackButton = "GameSceneSettingsBackButton"
    static let gameSceneSettingsVibroButton = "GameSceneSettingsVibroButton"
    static let gameSceneSettingsMusicButton = "GameSceneSettingsMusicButton"
    
    /// Game Top Score  Texture
    static let topScoreSceneBackground = "TopScoreSceneBackground"
    static let topScoreSceneTitleLabel = "TopScoreSceneTitleLabel"
    static let topScoreSceneBackButton = "TopScoreSceneBackButton"
    static let topScoreSceneNode = "TopScoreSceneNode"
    static let topScoreResetButton = "TopScoreResetButton"
    
    //FIXME: - Add Infobar Images
    ///Infobar
    
}

enum SoundFile {
    static let backgroundMusic = "MainGameMusic.mp3"
    static let slice = "Slice.caf"
    static let splash = "Splash.caf"
    static let nomNom = "NomNom.caf"
    
    static let priceSceneBackground = "PriceSceneBackground.mp3"
}

enum SoundType {
    case slice
    case splash
    case nomNom
}

enum BackgroundSoundType {
    case mainSceneBackground
    case topScoreSceneBackground
    case priceSceneBackground
}

enum Layers {
    static let background: CGFloat = 0
    static let emitter: CGFloat = 1
    static let crocodile: CGFloat = 1
    static let vine: CGFloat = 1
    static let prize: CGFloat = 3
    static let foreground: CGFloat = 4
    
    static let wood: CGFloat = 5
    static let physicalObjectOne: CGFloat = 5
    static let physicalObjectTwo: CGFloat = 5
    static let physicalObjectTree: CGFloat = 5
    static let physicalObjectFour: CGFloat = 5
    
    static let infobar: CGFloat = 10
    static let exitButton: CGFloat = 10
}

enum PhysicsCategoryBitMask {
    static let crocodile: UInt32 = 1
    static let vineHolder: UInt32 = 2
    static let vine: UInt32 = 4
    static let prize: UInt32 = 8
    static let wood: UInt32 = 16
    
    static let physicalObjectOne: UInt32 = 16
    static let physicalObjectTwo: UInt32 = 16
    static let physicalObjectThree: UInt32 = 16
    static let physicalObjectFour: UInt32 = 16
}

enum GameConfiguration {
    static let canCutMultipleVinesAtOnce = false
    static let maximumLevel = 11
}

enum SceneParticles {
    static let particles = "Particle.sks"
}

enum PrizeType: String {
    case common = "Common"
    case rare = "Rare"
    case unique = "Unique"
}

enum ObjectType: String, Codable {
    case wood = "Wood"
    
    case physicalObjectOne = "PhysicalObjectOne"
    case physicalObjectTwo = "PhysicalObjectTwo"
    case physicalObjectThree = "PhysicalObjectThree"
    case physicalObjectFour = "PhysicalObjectFour"
    
    case somethingNew = "SomethingNew"
    
    init(from decoder: Decoder) throws {
        let object = try decoder.singleValueContainer().decode(String.self)
        self = ObjectType(rawValue: object) ?? .somethingNew
    }
}

enum Emitter {
    static let rain = "Rain"
    static let dust = "Dust"
}

extension CaseIterable where Self: Equatable {
    var allCases: AllCases { Self.allCases }
    var next: Self {
        let index = allCases.index(after: allCases.firstIndex(of: self)!)
        guard index != allCases.endIndex else { return allCases.first! }
        return allCases[index]
    }
}
