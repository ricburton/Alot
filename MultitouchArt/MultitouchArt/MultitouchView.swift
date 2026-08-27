import SwiftUI
import UIKit

struct MultitouchView: UIViewRepresentable {
    @EnvironmentObject var soundManager: SoundManager
    
    func makeUIView(context: Context) -> MultitouchCanvas {
        let view = MultitouchCanvas()
        view.soundManager = soundManager
        return view
    }
    
    func updateUIView(_ uiView: MultitouchCanvas, context: Context) {}
}

class MultitouchCanvas: UIView {
    var particles: [UITouch: TouchParticle] = [:]
    var soundManager: SoundManager?
    private var displayLink: CADisplayLink?
    private let colors: [UIColor] = [
        .systemRed, .systemOrange, .systemYellow, .systemGreen,
        .systemTeal, .systemBlue, .systemIndigo, .systemPurple,
        .systemPink, .systemMint, .systemCyan
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .black
        isMultipleTouchEnabled = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    @objc private func update() {
        for particle in particles.values {
            particle.update()
        }
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let color = colors.randomElement() ?? .systemBlue
            let particle = TouchParticle(position: location, color: color)
            particles[touch] = particle
            
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            soundManager?.playTouchSound(frequency: Float.random(in: 300...800))
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let particle = particles[touch] {
                particle.position = location
                particle.addTrail(position: location)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            particles[touch]?.isEnding = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for touch in touches {
                self.particles.removeValue(forKey: touch)
            }
            self.setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setBlendMode(.normal)
        
        for particle in particles.values {
            particle.draw(in: context)
        }
    }
}
