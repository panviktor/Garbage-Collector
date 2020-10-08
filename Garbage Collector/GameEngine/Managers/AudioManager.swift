//
//  AVAudio.swift
//
//  Created by Guan Wong on 6/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit
import AVFoundation

final class AudioManager {
    enum AudioError: Error {
        case invalidFile
    }
    
    private var backgroundMusic: AVAudioPlayer?
    private let defaults = UserDefaults.standard
    
    private var musicStatus: Bool {
        get {
            return defaults.object(forKey: "musicStatus") as? Bool ?? true
        } set (newValue) {
            defaults.set(newValue, forKey: "musicStatus")
        }
    }
    
    private var vibroStatus: Bool {
        get {
            return defaults.object(forKey: "vibroStatus") as? Bool ?? true
        } set (newValue) {
            defaults.set(newValue, forKey: "vibroStatus")
        }
    }
    
    static let shared = AudioManager()
    
    fileprivate init() {}
    
    private func playMusic() {
        DispatchQueue.main.async {
            self.backgroundMusic?.play()
        }
    }
    
    func musicToggle() {
        musicStatus.toggle()
        musicStatus == true ? playMusic() : backgroundMusic?.stop()
    }
    
    func vibroToggle() {
        vibroStatus.toggle()
    }
    
    func playMusic(type: BackgroundSoundType) throws {
        backgroundMusic = nil
        guard musicStatus else { return }
        var urlToPlay: URL
        switch type {
        case .mainSceneBackground:
            guard let url = Bundle.main.url(forResource: SoundFile.backgroundMusic, withExtension: nil) else {
                throw AudioError.invalidFile
            }
            urlToPlay = url
        case .topScoreSceneBackground:
            guard let url = Bundle.main.url(forResource: SoundFile.backgroundMusic, withExtension: nil) else {
                throw AudioError.invalidFile
            }
            urlToPlay = url
        case .priceSceneBackground:
            guard let url = Bundle.main.url(forResource: SoundFile.priceSceneBackground, withExtension: nil) else {
                throw AudioError.invalidFile
            }
            urlToPlay = url
        }
        backgroundMusic = try AVAudioPlayer(contentsOf: urlToPlay)
        backgroundMusic?.numberOfLoops = -1
        
        playMusic()
    }
    
    func getAction(type: SoundType) -> SKAction {
        switch type {
        case .nomNom:
            let skCoinAction = SKAction.playSoundFileNamed(SoundFile.nomNom, waitForCompletion: false)
            vibroStatus ? UIDevice.vibrate() : ()
            return skCoinAction
        case .splash:
            let skPuffAction = SKAction.playSoundFileNamed(SoundFile.splash, waitForCompletion: false)
            return skPuffAction
        case .slice:
            let skPuffAction = SKAction.playSoundFileNamed(SoundFile.slice, waitForCompletion: false)
            return skPuffAction
        }
    }
    
    func stop() {
        backgroundMusic?.stop()
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
