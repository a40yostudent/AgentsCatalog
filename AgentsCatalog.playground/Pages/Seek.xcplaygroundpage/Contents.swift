/*
 Abstract:
 Demonstrates seek behavior. Click (OS X) or touch (iOS) and drag and the agent follows the mouse/touch location.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLSeekScene: AAPLGameScene {
    
    var player: AAPLAgentNode!
    var seekGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "SEEKING"
        
        // The player agent follows the tracking agent.
        player = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2,
                                                 y: self.size.height / 2))
        player.agent.behavior = GKBehavior()
        agentSystem.addComponent(player.agent)
        
        // Create the seek goal, but add it to the behavior only in setSeeking:.
        seekGoal = GKGoal(toSeekAgent: trackingAgent)
        
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
    
}


let scene = AAPLSeekScene(size: CGSize(width: 600, height: 800))
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
