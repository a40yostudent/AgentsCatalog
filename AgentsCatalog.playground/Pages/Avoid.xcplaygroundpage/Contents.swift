/*
 Abstract:
 Demonstrates avoid-obstacles behavior. Click (OS X) or touch (iOS) and drag and the agent follows the mouse/touch location, but avoids passing through the red obstacles.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLAvoidScene: AAPLGameScene {
    
    var player: AAPLAgentNode!
    var seekGoal: GKGoal!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "AVOID OBSTACLES"
        
        let obstacles = [addObstacle(at: CGPoint(x: self.size.width / 2,
                                                 y: self.size.height / 2 + 150)),
                         addObstacle(at: CGPoint(x: self.size.width / 2 - 200,
                                                 y: self.size.height / 2 - 150)),
                         addObstacle(at: CGPoint(x: self.size.width / 2 + 200,
                                                 y: self.size.height / 2 - 150))]
        
        // The player agent follows the tracking agent.
        player = AAPLAgentNode(scene: self,
                               radius: AAPLDefaultAgentRadius,
                               position: CGPoint(x: self.size.width / 2,
                                                 y: self.size.height / 2))
        player.agent.behavior = GKBehavior()
        agentSystem.addComponent(player.agent)
        
        // Create the seek goal, but add it to the behavior only in setSeeking:.
        seekGoal = GKGoal(toSeekAgent: trackingAgent)
        
        // Add an avoid-obstacles goal with a high weight to keep the agent from overlapping the obstacles.
        player.agent.behavior = GKBehavior(goal: GKGoal(toAvoid: obstacles, maxPredictionTime: 1), weight: 100)
        
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
    
    func addObstacle(at point: CGPoint) -> GKObstacle {
        
        let circleShape = SKShapeNode(circleOfRadius: CGFloat(AAPLDefaultAgentRadius))
        circleShape.lineWidth = 2.5
        circleShape.fillColor = .gray
        circleShape.strokeColor = .red
        circleShape.zPosition = 1
        circleShape.position = point
        self.addChild(circleShape)
        
        let obstacle = GKCircleObstacle(radius: AAPLDefaultAgentRadius)
        obstacle.position = float2(Float(point.x), Float(point.y))
        return obstacle
        
    }
    
}


let scene = AAPLAvoidScene(size: CGSize(width: 600, height: 800))
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

