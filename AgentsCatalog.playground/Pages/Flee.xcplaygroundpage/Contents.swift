/*
 Abstract:
 Demonstrates flee behavior. Click (OS X) or touch (iOS) and drag; the white agent follows the mouse/touch location, and the red agent avoids the white agent.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLFleeScene: AAPLGameScene {
    
    var player: AAPLAgentNode!
    var enemy: AAPLAgentNode!
    var seekGoal: GKGoal!
    var fleeGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "FLEEING"
        
        // The player agent follows the tracking agent.
        player = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2 - 150,
                                                 y: self.size.height / 2))
        player.agent.behavior = GKBehavior()
        agentSystem.addComponent(player.agent)
        
        // The enemy agent flees from the player agent.
        enemy = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2 + 150,
                                                 y: self.size.height / 2))
        enemy.color = .red
        enemy.agent.behavior = GKBehavior()
        agentSystem.addComponent(enemy.agent)
        
        // Create seek and flee goals, but add them to the agents' behaviors only in -setSeeking: / -setFleeing:.
        seekGoal = GKGoal(toSeekAgent: trackingAgent)
        fleeGoal = GKGoal(toFleeAgent: player.agent)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let distance = simd_distance(player.agent.position, enemy.agent.position)
        
        let maxDistance: Float = 200.0
        set(fleeing: distance < maxDistance)
        
        super.update(currentTime)
    }
    
    override func set(seeking: Bool) {
        // Switch between enabling seek and stop goals so that the agent stops when not seeking.
        if seeking == true {
            player.agent.behavior?.setWeight(1, for: seekGoal)
            player.agent.behavior?.setWeight(0, for: stopGoal)
        } else {
            player.agent.behavior?.setWeight(0, for: seekGoal)
            player.agent.behavior?.setWeight(1, for: stopGoal)
        }
    }
    
    func set(fleeing: Bool) {
        // Switch between enabling seek and stop goals so that the agent stops when not seeking.
        if fleeing == true {
            enemy.agent.behavior?.setWeight(1, for: fleeGoal)
            enemy.agent.behavior?.setWeight(0, for: stopGoal)
        } else {
            enemy.agent.behavior?.setWeight(0, for: fleeGoal)
            enemy.agent.behavior?.setWeight(1, for: stopGoal)
        }
    }
    
}

let scene = AAPLFleeScene(size: CGSize(width: 600, height: 800))
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
