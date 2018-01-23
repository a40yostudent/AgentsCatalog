/*
 Abstract:
 Demonstrates flocking behavior -- a combination of separation, alignment, and cohesion goals. Click (OS X) or touch (iOS) and drag and the flock of agents follows the mouse/touch location together.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLFlockScene: AAPLGameScene {
    
    var seekGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        name = "FLOCKING"
        
        // Create a flock of similar agents.
        var agents = [GKAgent2D](repeating: GKAgent2D(), count: 20)
        let agentsPerRow = 4
        
        for i in 0..<(agentsPerRow * agentsPerRow) {
            let x = CGFloat(Int(self.size.width / 2) + (i % agentsPerRow) * 20)
            let y = CGFloat(Int(self.size.height / 2) + (i / agentsPerRow) * 20)
            let boid = AAPLAgentNode(scene: self,
                                     radius: 10,
                                     position: CGPoint(x: x, y: y))
            agentSystem.addComponent(boid.agent)
            agents.append(boid.agent)
            boid.drawsTrail = false
        }
        
        let separationRadius: Float = 0.553 * 50
        let separationAngle: Float = .pi * 3 / 4.0
        let separationWeight: Float = 10.0
        
        let alignmentRadius: Float = 0.83333 * 50
        let alignmentAngle: Float = .pi / 4.0
        let alignmentWeight: Float = 12.66
        
        let cohesionRadius: Float = 1.0 * 100
        let cohesionAngle: Float = .pi / 2.0
        let cohesionWeight: Float = 8.66
        
        // Separation, alignment, and cohesion goals combined cause the flock to move as a group.
        let behavior = GKBehavior()
        behavior.setWeight(separationWeight, for: GKGoal(toSeparateFrom: agents,
                                                         maxDistance: separationRadius,
                                                         maxAngle: separationAngle))
        behavior.setWeight(alignmentWeight, for: GKGoal(toAlignWith: agents,
                                                        maxDistance: alignmentRadius,
                                                        maxAngle: alignmentAngle))
        behavior.setWeight(cohesionWeight, for: GKGoal(toCohereWith: agents,
                                                       maxDistance: cohesionRadius,
                                                       maxAngle: cohesionAngle))
        for agent in agents {
            agent.behavior = behavior
        }
        
        // Create the seek goal, but add it to the behavior only in setSeeking:.
        seekGoal = GKGoal(toSeekAgent: trackingAgent)
    }
    
    override func set(seeking: Bool) {
        for agent in agentSystem.components {
            if seeking == true {
                agent.behavior?.setWeight(1, for: seekGoal)
            } else {
                agent.behavior?.setWeight(0, for: seekGoal)
            }
        }
    }
}

let scene = AAPLFlockScene(size: CGSize(width: 600, height: 800))
scene.scaleMode = .aspectFit
let rect = CGRect(origin: CGPoint.zero, size: scene.size)
let view = SKView(frame: rect)
view.isMultipleTouchEnabled = false
view.ignoresSiblingOrder = true
view.showsFPS = true
view.showsNodeCount = true
view.showsPhysics = false
view.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view


