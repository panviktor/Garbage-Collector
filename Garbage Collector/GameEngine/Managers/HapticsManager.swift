//
//  Haptics.swift
//  Garbage Collector
//
//  Created by Viktor on 07.10.2020.
//

import CoreHaptics

final class HapticManager {
    private let hapticEngine: CHHapticEngine
    private var sliceAudio: CHHapticAudioResourceID?
    private var nomNomAudio: CHHapticAudioResourceID?
    private var splashAudio: CHHapticAudioResourceID?
    private var swishPlayer: CHHapticAdvancedPatternPlayer?
    
    // Failable initializer: the game will ignore haptics if the manager is nil
    init?() {
        let defaults = UserDefaults.standard
        
        // Check if the device supports haptics and fail the initializer if it doesn't
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        
        var vibroStatus: Bool {
                defaults.object(forKey: "vibroStatus") as? Bool ?? true
        }
        
        guard hapticCapability.supportsHaptics && (defaults.object(forKey: "vibroStatus") as? Bool ?? true) else {
            return nil
        }
        
        // Try to ceate the engine, fail the initializer if it fails
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
        
        do {
            try hapticEngine.start()
        } catch let error {
            print("Haptic failed to start Error: \(error)")
        }
        
        hapticEngine.isAutoShutdownEnabled = true
        
        hapticEngine.resetHandler = { [weak self] in
            self?.handleEngineReset()
        }
        
        // Setup our audio resources
        setupResources()
    }
    
    private func handleEngineReset() {
        print("Engine is resetting...")
        do {
            try hapticEngine.start()
            setupResources()
            createSwishPlayer()
        } catch {
            print("Failed to restart the engine: \(error)")
        }
    }
    
    private func setupResources() {
        do {
            if let path = Bundle.main.url(forResource: "Slice", withExtension: "caf") {
                sliceAudio = try hapticEngine.registerAudioResource(path)
            }
            if let path = Bundle.main.url(forResource: "NomNom", withExtension: "caf") {
                nomNomAudio = try hapticEngine.registerAudioResource(path)
            }
            if let path = Bundle.main.url(forResource: "Splash", withExtension: "caf") {
                splashAudio = try hapticEngine.registerAudioResource(path)
            }
        } catch {
            print("Failed to load audio: \(error)")
        }
        
        createSwishPlayer()
    }
    
    // MARK: - Dynamic Swish Player
    private func createSwishPlayer() {
        let swish = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            ],
            relativeTime: 0,
            duration: 60)
        
        do {
            let pattern = try CHHapticPattern(events: [swish], parameters: [])
            swishPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
        } catch let error {
            print("Swish player error: \(error)")
        }
    }
    
    func startSwishPlayer() {
        do {
            try hapticEngine.start()
            try swishPlayer?.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Swish player start error: \(error)")
        }
    }
    
    func stopSwishPlayer() {
        do {
            try swishPlayer?.stop(atTime: CHHapticTimeImmediate)
        } catch {
            print("Swish player stop error: \(error)")
        }
    }
    
    func updateSwishPlayer(intensity: Float) {
        let intensity = CHHapticDynamicParameter(
            parameterID: .hapticIntensityControl,
            value: intensity,
            relativeTime: 0)
        do {
            try swishPlayer?.sendParameters([intensity], atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Swish player dynamic update error: \(error)")
        }
    }
    
    // MARK: - Play Haptic Patterns
    func playSlice() {
        do {
            let pattern = try slicePattern()
            try playHapticFromPattern(pattern)
        } catch {
            print("Failed to play slice: \(error)")
        }
    }
    
    func playNomNom() {
        do {
            let pattern = try nomNomPattern()
            try playHapticFromPattern(pattern)
        } catch {
            print("Failed to play nomNom: \(error)")
        }
    }
    
    func playSplash() {
        do {
            let pattern = try splashPattern()
            try playHapticFromPattern(pattern)
        } catch {
            print("Failed to play splash: \(error)")
        }
    }
    
    private func playHapticFromPattern(_ pattern: CHHapticPattern) throws {
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
    }
}

// MARK: - Haptic Patterns
extension HapticManager {
    private func slicePattern() throws -> CHHapticPattern {
        let slice = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            ],
            relativeTime: 0,
            duration: 0.5)
        
        let snip = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            ],
            relativeTime: 0.08)
        
        let curve = CHHapticParameterCurve(
            parameterID: .hapticIntensityControl,
            controlPoints: [
                .init(relativeTime: 0, value: 0.2),
                .init(relativeTime: 0.08, value: 1.0),
                .init(relativeTime: 0.24, value: 0.2),
                .init(relativeTime: 0.34, value: 0.6),
                .init(relativeTime: 0.5, value: 0)
            ],
            relativeTime: 0)
        
        var events = [slice, snip]
        if let audioResourceID = sliceAudio {
            let audio = CHHapticEvent(audioResourceID: audioResourceID, parameters: [], relativeTime: 0)
            events.append(audio)
        }
        
        return try CHHapticPattern(events: events, parameterCurves: [curve])
    }
    
    private func nomNomPattern() throws -> CHHapticPattern {
        let rumble1 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0,
            duration: 0.15)
        
        let rumble2 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            ],
            relativeTime: 0.3,
            duration: 0.3)
        
        let crunch1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            ],
            relativeTime: 0)
        
        let crunch2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0.3)
        
        var events = [rumble1, rumble2, crunch1, crunch2]
        if let audioResourceID = nomNomAudio {
            let audio = CHHapticEvent(audioResourceID: audioResourceID, parameters: [], relativeTime: 0)
            events.append(audio)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
    
    private func splashPattern() throws -> CHHapticPattern {
        let splish = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            ],
            relativeTime: 0)
        
        let splash = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1),
                CHHapticEventParameter(parameterID: .attackTime, value: 0.1),
                CHHapticEventParameter(parameterID: .releaseTime, value: 0.2),
                CHHapticEventParameter(parameterID: .decayTime, value: 0.3)
            ],
            relativeTime: 0.1,
            duration: 0.6)
        
        var events = [splish, splash]
        if let audioResourceID = splashAudio {
            let audio = CHHapticEvent(audioResourceID: audioResourceID, parameters: [], relativeTime: 0)
            events.append(audio)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
}
