import SpriteKit

class GameScene: SKScene {
    var game = Game()
    var mrsChicken : SKNode!
    var eggs:[String:SKNode] = [:]
    var chicks:[String:SKNode] = [:]
    override func didMoveToView(view: SKView) {
        mrsChicken = self.childNodeWithName("mrsChicken")
    }
    #if os(iOS)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            game.chicken.destination = location
        }
    }
    #endif
    #if os(OSX)
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        
        game.chicken.destination = location
    }
    #endif
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
        
        for egg in game.eggs {
            if eggs[egg.id] == nil {
                let eggNode = SKSpriteNode(imageNamed: "Egg")
                eggNode.setScale(CGFloat(0.6))
                eggNode.position = egg.location
                eggs[egg.id] = eggNode
                self.addChild(eggNode)
            }
        }
        
        for chick in game.chicks {
            if let egg = eggs[chick.id] {
                removeChildrenInArray([egg])
                let chickNode = SKSpriteNode(imageNamed: "Chick")
                chickNode.setScale(CGFloat(0.6))
                chickNode.position = chick.location
                chicks[chick.id] = chickNode
                eggs.removeValueForKey(chick.id)
                if chick.facing == .Right {
                    chickNode.xScale = -0.6
                } else {
                    chickNode.xScale = 0.6
                }
                self.addChild(chickNode)
            }
            if let chickNode = chicks[chick.id] {
                chickNode.position = chick.location
                if chick.location.x < -15 || chick.location.x > frame.width + 15 {
                    removeChildrenInArray([chicks[chick.id]!])
                    chick.outOfBounds = true
                }
            }
        }
    }
}
