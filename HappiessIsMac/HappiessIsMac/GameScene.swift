import SpriteKit

class GameScene: SKScene {
    var game = Game()
    var mrsChicken : SKNode!
    override func didMoveToView(view: SKView) {
        mrsChicken = self.childNodeWithName("mrsChicken")
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        
        game.chicken.destination = location
    }
    
    override func update(currentTime: CFTimeInterval) {
        game.update(currentTime:currentTime)
        mrsChicken.position = game.chicken.location
        
        if game.chicken.facing == .Right {
            mrsChicken.xScale = -1
        } else {
            mrsChicken.xScale = 1
        }
        
        if !game.chicken.isStanding && nil == mrsChicken.actionForKey("walk") {
            let walk:SKAction = SKAction.repeatActionForever( SKAction(named: "chickenWalk")!)
            mrsChicken.runAction(walk, withKey: "walk")
        }
        else if game.chicken.isStanding && nil != mrsChicken.actionForKey("walk") {
            mrsChicken.removeActionForKey("walk")
        }
        
    }
}
