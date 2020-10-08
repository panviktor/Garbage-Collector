final class SceneManager {
    static let shared = SceneManager()
    var mainScene: MainScene?
    var gameScene: GameScene?
    fileprivate init() {}
}
