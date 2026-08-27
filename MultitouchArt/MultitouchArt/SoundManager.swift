import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var playerNodes: [AVAudioPlayerNode] = []
    private let maxNodes = 10
    private var currentNodeIndex = 0
    
    init() {
        audioEngine = AVAudioEngine()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        
        setupAudioNodes()
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    private func setupAudioNodes() {
        let mainMixer = audioEngine.mainMixerNode
        
        for _ in 0..<maxNodes {
            let playerNode = AVAudioPlayerNode()
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: mainMixer, format: nil)
            playerNodes.append(playerNode)
        }
    }
    
    func playTouchSound(frequency: Float = 440) {
        let playerNode = playerNodes[currentNodeIndex]
        currentNodeIndex = (currentNodeIndex + 1) % maxNodes
        
        if playerNode.isPlaying {
            playerNode.stop()
        }
        
        let sampleRate = 44100.0
        let duration = 0.15
        let frameCount = UInt32(duration * sampleRate)
        
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            return
        }
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return
        }
        
        buffer.frameLength = frameCount
        
        let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(format.channelCount))
        let floats = UnsafeMutableBufferPointer<Float>(start: channels[0], count: Int(frameCount))
        
        let frequencyVariation = Float.random(in: -50...50)
        let actualFrequency = frequency + frequencyVariation
        
        for frame in 0..<Int(frameCount) {
            let time = Float(frame) / Float(sampleRate)
            let envelope = Float(1.0 - Double(frame) / Double(frameCount))
            
            let sine = sin(2.0 * Float.pi * actualFrequency * time)
            let harmonicSine = sin(2.0 * Float.pi * actualFrequency * 2.0 * time) * 0.3
            
            floats[frame] = (sine + harmonicSine) * envelope * 0.3
        }
        
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
    }
    
    deinit {
        audioEngine.stop()
    }
}
