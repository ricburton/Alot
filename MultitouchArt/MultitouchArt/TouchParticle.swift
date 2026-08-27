import UIKit
import CoreGraphics

class TouchParticle {
    var position: CGPoint
    var color: UIColor
    var radius: CGFloat = 60
    var alpha: CGFloat = 1.0
    var isEnding = false
    var trail: [CGPoint] = []
    private let maxTrailLength = 30
    
    init(position: CGPoint, color: UIColor) {
        self.position = position
        self.color = color
    }
    
    func update() {
        if isEnding {
            alpha *= 0.95
            radius *= 1.05
        }
        
        if trail.count > maxTrailLength {
            trail.removeFirst()
        }
    }
    
    func addTrail(position: CGPoint) {
        trail.append(position)
    }
    
    func draw(in context: CGContext) {
        context.saveGState()
        
        if trail.count > 1 {
            for (index, point) in trail.enumerated() {
                let trailAlpha = CGFloat(index) / CGFloat(trail.count) * alpha * 0.3
                let trailRadius = radius * 0.5 * (CGFloat(index) / CGFloat(trail.count))
                
                context.setFillColor(color.withAlphaComponent(trailAlpha).cgColor)
                context.fillEllipse(in: CGRect(
                    x: point.x - trailRadius,
                    y: point.y - trailRadius,
                    width: trailRadius * 2,
                    height: trailRadius * 2
                ))
            }
        }
        
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                color.withAlphaComponent(alpha * 0.8).cgColor,
                color.withAlphaComponent(alpha * 0.4).cgColor,
                color.withAlphaComponent(0).cgColor
            ] as CFArray,
            locations: [0.0, 0.5, 1.0]
        )
        
        if let gradient = gradient {
            context.drawRadialGradient(
                gradient,
                startCenter: position,
                startRadius: 0,
                endCenter: position,
                endRadius: radius,
                options: []
            )
        }
        
        let glowGradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                UIColor.white.withAlphaComponent(alpha * 0.6).cgColor,
                color.withAlphaComponent(alpha * 0.3).cgColor,
                color.withAlphaComponent(0).cgColor
            ] as CFArray,
            locations: [0.0, 0.3, 1.0]
        )
        
        if let glowGradient = glowGradient {
            context.drawRadialGradient(
                glowGradient,
                startCenter: position,
                startRadius: 0,
                endCenter: position,
                endRadius: radius * 0.4,
                options: []
            )
        }
        
        context.restoreGState()
    }
}
