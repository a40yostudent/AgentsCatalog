/*
 Abstract:
 Non-interactive demonstration of wander behavior.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLWanderScene: AAPLGameScene {
    
    var wanderer: AAPLAgentNode!
    var seekGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "WANDERING"
        
        // The player agent follows the tracking agent.
        wanderer = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2,
                                                 y: self.size.height / 2))
        wanderer.color = .cyan
        wanderer.agent.behavior = GKBehavior(goal: GKGoal(toWander: 10), weight: 100)
        agentSystem.addComponent(wanderer.agent)
        
    }
    
}


let scene = AAPLWanderScene(size: CGSize(width: 600, height: 800))
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
