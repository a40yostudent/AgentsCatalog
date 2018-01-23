/*
 Abstract:
 A SpriteKit node whose position is managed by a GameplayKit agent. Also provides the standard appearance for agents in this demo.
 */

import SpriteKit
import GameplayKit

open class AAPLAgentNode: SKNode {
    
    public let agent = GKAgent2D()
    
    public var triangleShape: SKShapeNode!
    public var particles: SKEmitterNode!
    public var defaultParticleRate: CGFloat!
    
    public var drawsTrail: Bool = false {
        didSet {
            if drawsTrail == true {
                self.particles.particleBirthRate = self.defaultParticleRate
            } else {
                self.particles.particleBirthRate = 0
            }
        }
    }
    
    public var color: SKColor {
        get {
            return self.triangleShape.strokeColor
        }
        set {
            self.triangleShape.strokeColor = newValue
        }
    }
    
    public init(scene: SKScene, radius: Float = AAPLDefaultAgentRadius, position: CGPoint) {
        
        super.init()
        
        self.position = position
        self.zPosition = 10
        scene.addChild(self)
        
        // An agent to manage the movement of this node in a scene.
        agent.radius = radius
        agent.position = float2(Float(position.x), Float(position.y))
        agent.delegate = self
        agent.maxSpeed = 100
        agent.maxAcceleration = 50
        
        // A circle to represent the agent's radius in the agent simulation.
        let circleShape = SKShapeNode(circleOfRadius: CGFloat(radius))
        circleShape.lineWidth = 2.5
        circleShape.fillColor = .gray
        circleShape.zPosition = 1
        self.addChild(circleShape)
        
        // A triangle to represent the agent's heading (rotation) in the agent simulation.
        var points = [CGPoint](repeatElement(CGPoint(), count: 4))
        let triangleBackSideAngle = (135.0 / 360.0) * (2 * .pi)
        points[0] = CGPoint(x: Double(radius), y: 0) // Tip.
        points[1] = CGPoint(x: Double(radius) * cos(triangleBackSideAngle), y: Double(radius) * sin(triangleBackSideAngle)) // Back bottom.
        points[2] = CGPoint(x: Double(radius) * cos(triangleBackSideAngle), y: Double(-radius) * sin(triangleBackSideAngle)) // Back top.
        points[3] = CGPoint(x: Double(radius), y: 0) // Back top.
        triangleShape = SKShapeNode(points: &points, count: 4)
        triangleShape.lineWidth = 2.5
        triangleShape.zPosition = 1
        self.addChild(triangleShape)
        
        // A particle effect to leave a trail behind the agent as it moves through the scene.
        particles = SKEmitterNode(fileNamed: "Trail.sks")
        defaultParticleRate = particles.particleBirthRate
        particles.position = CGPoint(x: Double(-radius) + 5,y: 0)
        particles.targetNode = scene
        particles.zPosition = 0
        self.addChild(particles)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AAPLAgentNode: GKAgentDelegate {
    
    open func agentWillUpdate(_ agent: GKAgent) {
        // All changes to agents in this app are driven by the agent system, so there's no other changes to pass into the agent system in this method.
    }
    
    open func agentDidUpdate(_ agent: GKAgent) {
        // Agent and sprite use the same coordinate system (in this app), so just convert vector_float2 position to CGPoint.
        let agent = agent as! GKAgent2D
        self.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
        self.zRotation = CGFloat(agent.rotation)
    }
    
}

