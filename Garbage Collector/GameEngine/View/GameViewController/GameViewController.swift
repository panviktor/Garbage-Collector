import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private let screenSize = UIScreen.main.bounds.size
    private let audioVibroManager = AudioManager.shared
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func loadView() {
        self.view = SKView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Custom Methods
    private func load(){
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true

//      let scene = GameScene(size: CGSize(width: 375, height: 667))
        let scene = MainScene(size: screenSize)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}

