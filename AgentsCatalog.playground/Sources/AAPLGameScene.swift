/*
 Abstract:
 Common superclass for the scenes in this demo. Manages an update loop for agents, and provides a mouse/touch tracking agent for use in some of the demo scenes.
 */

import SpriteKit
import GameplayKit

open class AAPLGameScene: SKScene {
    
    // A component system to manage per-frame updates for all agents.
    public var agentSystem: GKComponentSystem<GKAgent2D>!
    
    // An agent whose position tracks that of mouseDragged (OS X) or touchesMoved (iOS) events.
    // This agent has no display representation, but can be used to make other agents follow the mouse/touch.
    public var trackingAgent: GKAgent2D!
    
    // YES when the mouse is dragging (OS X) or a touch is moving
    public var seeking: Bool = false
    
    public let stopGoal: GKGoal = GKGoal(toReachTargetSpeed: 0)
    
    public var lastUpdateTime: TimeInterval = 0.0
    
    public override init(size: CGSize) {
        super.init(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func didMove(to view: SKView) {
        trackingAgent = GKAgent2D()
        agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        trackingAgent.position = float2(Float(self.frame.width / 2), Float(self.frame.height / 2))
    }
    
    open override func update(_ currentTime: TimeInterval) {
        // Calculate delta since last update and pass along to the agent system.
        if lastUpdateTime == 0.0 { lastUpdateTime = currentTime }
        
        let delta: Double = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        self.agentSystem.update(deltaTime: delta)
    }
    
    open func set(seeking: Bool) {
        print("override set(seeking: ) or disable user interaction")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        set(seeking: true)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        set(seeking: false)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        set(seeking: false)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position: CGPoint = touch.location(in: self)
            self.trackingAgent.position = float2(Float(position.x), Float(position.y))
        }
    }
    
}
