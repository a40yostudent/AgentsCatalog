/*
 Abstract:
 Demonstrates alignment behavior. Click (OS X) or touch (iOS) and drag; the white agent follows the mouse/touch location, and the cyan agents maintain the same heading as the white agent whenever the white agent is near.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLAlignScene: AAPLGameScene {
    
    var player: AAPLAgentNode!
    var friends: [AAPLAgentNode]!
    var seekGoal: GKGoal!
    var alignGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "ALIGNMENT"
        
        // The player agent follows the tracking agent.
        player = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2,
                                                 y: self.size.height / 2))
        player.agent.behavior = GKBehavior()
        agentSystem.addComponent(player.agent)
        player.agent.maxSpeed *= 1.2
        
        // Create the seek goal, but add it to the behavior only in -setSeeking:.
        seekGoal = GKGoal(toSeekAgent: trackingAgent)
        
        // The friend agents attempt to maintain consistent direction with the player agent.
        alignGoal = GKGoal(toAlignWith: [player.agent], maxDistance: 100, maxAngle: .pi * 2)
        let behavior = GKBehavior(goal: alignGoal, weight: 100)
        friends = [addFriend(at: CGPoint(x: self.size.width / 2 - 150,
                                         y: self.size.height / 2)),
                   addFriend(at: CGPoint(x: self.size.width / 2 + 150,
                                         y: self.size.height / 2))]
        for friend in friends {
            friend.agent.behavior = behavior
        }
    }
    
    override func set(seeking: Bool) {
        // Switch between enabling seek and stop goals so that the agent stops when not seeking.
        for agent in agentSystem.components {
            if seeking == true {
                agent.behavior?.setWeight(1, for: seekGoal)
                agent.behavior?.setWeight(0, for: stopGoal)
            } else {
                agent.behavior?.setWeight(0, for: seekGoal)
                agent.behavior?.setWeight(1, for: stopGoal)
            }
        }
    }
    
    func addFriend(at point: CGPoint) -> AAPLAgentNode {
        let friend = AAPLAgentNode(scene: self,
                                   radius: AAPLDefaultAgentRadius,
                                   position: point)
        friend.color = .cyan
        agentSystem.addComponent(friend.agent)
        return friend
    }
    
}

let scene = AAPLAlignScene(size: CGSize(width: 600, height: 800))
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

