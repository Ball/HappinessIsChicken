import SpriteKit
import AudioToolbox

class GameScene: SKScene {
    #if os(OSX)
    var walkSound = NSSound(named:"Purr")
    #endif
    var game = Game()
    var mrsChicken : SKNode!
    var eggs:[String:SKNode] = [:]
    var chicks:[String:SKNode] = [:]
    override func didMove(to view: SKView) {
        mrsChicken = self.childNode(withName: "mrsChicken")
        #if os(OSX)
        walkSound?.loops = true
        #endif
    }
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            game.chicken.destination = location
        }
    }
    #endif
    #if os(OSX)
    override func mouseDown(with theEvent: NSEvent) {
        let location = theEvent.location(in: self)
        
        game.chicken.destination = location
    }
    #endif
    override func update(_ currentTime: TimeInterval) {
        game.update(currentTime)
        mrsChicken.position = game.chicken.location
        
        if game.chicken.facing == .right {
            mrsChicken.xScale = -1
        } else {
            mrsChicken.xScale = 1
        }
        
        if !game.chicken.isStanding && nil == mrsChicken.action(forKey: "walk") {
            let walk:SKAction = SKAction.repeatForever( SKAction(named: "chickenWalk")!)
            mrsChicken.run(walk, withKey: "walk")
            #if os(OSX)
                walkSound?.play()
            #endif
        }
        else if game.chicken.isStanding && nil != mrsChicken.action(forKey: "walk") {
            mrsChicken.removeAction(forKey: "walk")
            #if os(OSX)
                walkSound?.stop()
            #endif

        }
        
        for egg in game.eggs {
            if eggs[egg.id] == nil {
                let eggNode = SKSpriteNode(imageNamed: "Egg")
                eggNode.setScale(CGFloat(0.6))
                eggNode.position = egg.location
                eggs[egg.id] = eggNode
                #if os(OSX)
                    NSSound(named: "Pop")?.play()
                #endif
                self.addChild(eggNode)
            }
        }
        
        for chick in game.chicks {
            if let egg = eggs[chick.id] {
                removeChildren(in: [egg])
                let chickNode = SKSpriteNode(imageNamed: "Chick")
                chickNode.setScale(CGFloat(0.6))
                chickNode.position = chick.location
                chicks[chick.id] = chickNode
                eggs.removeValue(forKey: chick.id)
                if chick.facing == .right {
                    chickNode.xScale = -0.6
                } else {
                    chickNode.xScale = 0.6
                }
                #if os(OSX)
                    NSSound(named:"Tink")?.play()
                #endif
                #if os(iOS)
                    AudioServicesPlaySystemSound(1057)
                #endif
                self.addChild(chickNode)
            }
            if let chickNode = chicks[chick.id] {
                chickNode.position = chick.location
                if chick.location.x < -15 || chick.location.x > frame.width + 15 {
                    removeChildren(in: [chicks[chick.id]!])
                    chick.outOfBounds = true
                }
            }
        }
    }
}
