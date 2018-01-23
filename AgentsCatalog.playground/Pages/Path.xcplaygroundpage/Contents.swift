/*
 Abstract:
 Demonstrates flocking behavior -- a combination of separation, alignment, and cohesion goals. Click (OS X) or touch (iOS) and drag and the flock of agents follows the mouse/touch location together.
 */

import SpriteKit
import GameplayKit
import PlaygroundSupport

class AAPLPathScene: AAPLGameScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        name = "FOLLLOW PATH"
        
        let follower = AAPLAgentNode(scene: self,
                                     radius: AAPLDefaultAgentRadius,
                                     position: CGPoint(x: self.size.width / 2,
                                                       y: self.size.height / 2))
        follower.color = .cyan
        
        // A closed path with a few arbitrary points relative to the center of the scene.
        let center = float2(Float(self.frame.width / 2),
                            Float(self.frame.height / 2))
        let points = [ float2(center.x, center.y + 50),
                       float2(center.x + 50, center.y + 150),
                       float2(center.x + 100, center.y + 150),
                       float2(center.x + 200, center.y + 200),
                       float2(center.x + 350, center.y + 150),
                       float2(center.x + 300, center.y),
                       float2(center.x, center.y  - 200),
                       float2(center.x - 200, center.y  - 100),
                       float2(center.x - 200, center.y),
                       float2(center.x - 100, center.y + 50)]
        
        // Create a behavior that makes the agent follow along the path.
        let path = GKPath(points: points, radius: 10, cyclical: true)
        
        follower.agent.behavior = GKBehavior(goal: GKGoal.init(toFollow: path,
                                                               maxPredictionTime: 1.5,
                                                               forward: true),
                                             weight: 1)
        agentSystem.addComponent(follower.agent)
        
        // Draw the path.
        var cgPoints = [CGPoint](repeating: CGPoint(), count: 11)
        for i in 0..<(cgPoints.count - 1) {
            cgPoints[i] = CGPoint(x: Double(points[i].x), y: Double(points[i].y))
        }
        cgPoints[10] = cgPoints[0] // Repeat the last point to create a closed path.
        let pathShape = SKShapeNode(points: &cgPoints, count: 11)
        pathShape.lineWidth = 2
        pathShape.strokeColor = .magenta
        self.addChild(pathShape)
    }
}

let scene = AAPLPathScene(size: CGSize(width: 600, height: 800))
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



