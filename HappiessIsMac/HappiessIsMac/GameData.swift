import Foundation
import CoreGraphics

func distanceBetween(p1 p1: CGPoint, andP2 p2: CGPoint) -> CGFloat {
    let dy = (p1.y - p2.y)
    let dx = (p1.x - p2.x)
    return hypot(dy, dx)
}
enum Facing {
    case Right
    case Left
}

class Chicken {
    private let STEP_SIZE = CGFloat(10.0)
    var location:CGPoint = CGPoint(x: 300, y: 300)
    var facing:Facing = .Right
    var isStanding = true
    var isLaying = false
    var destination:CGPoint = CGPoint(x: 300, y: 300) {
        didSet {
            isStanding = false
        }
    }
    func lay(currentTime: CFTimeInterval) -> Egg{
        isLaying = false
        return Egg(momma:self, hatchingAt: currentTime + CFTimeInterval(3))
    }
    func update(currentTime:CFTimeInterval) {
        if isStanding { return }
        if location == destination {
            isStanding = true
            isLaying = true
        }
        if distanceBetween(p1: location, andP2: destination) <= STEP_SIZE {
            location = destination
        } else {
            let angle = atan( (location.y - destination.y) / (location.x - destination.x))
            
            let dx = cos(angle) * STEP_SIZE
            let dy = sin(angle) * STEP_SIZE
            
            let isRight = location.x < destination.x
            let isUp = location.y > destination.y
            location.x = isRight ? location.x + abs(dx) : location.x - abs(dx)
            location.y = isUp ? location.y - abs(dy) : location.y + abs(dy)
            facing = isRight ? .Right : .Left
        }
    }
}

class Egg {
    var location:CGPoint
    var facing:Facing
    var hatchAt: NSTimeInterval
    var hatched: Bool
    var id: String
    init(momma: Chicken, hatchingAt: CFTimeInterval) {
        location = momma.location
        facing = momma.facing
        hatchAt = hatchingAt
        hatched = false
        id = NSUUID().UUIDString
    }
}

class Chick {
    private let STEP_SIZE = CGFloat(15)
    var location:CGPoint
    var facing:Facing
    var id:String
    var outOfBounds:Bool = false
    init(egg:Egg){
        location = egg.location
        facing = egg.facing
        id = egg.id
    }
    func update() {
        location.x = location.x + (facing == .Right ? STEP_SIZE : -STEP_SIZE)
    }
}

class Game {
    var chicken:Chicken
    var eggs:[Egg]
    var chicks:[Chick]
    var hatchingSeason:Bool = false
    init(){
        chicken = Chicken()
        eggs = []
        chicks = []
    }
    func eggsToHatch(atTime currentTime: CFTimeInterval) -> [Egg]{
        return eggs.filter({e in e.hatchAt <= currentTime })
    }
    
    func update(currentTime currentTime: CFTimeInterval) {
        chicken.update(currentTime)
        if chicken.isLaying {
            eggs.append(chicken.lay(currentTime))
        }
        
        if eggs.count >= 10 && !hatchingSeason {
            hatchingSeason = true
        }
        if eggs.count == 0 && chicks.count == 0  && hatchingSeason {
            hatchingSeason = false
        }
        
        if hatchingSeason {
            let hatchingEggs = eggs.filter({e in e.hatchAt <= currentTime})
            if hatchingEggs.count > 0 {
                let newChicks = hatchingEggs.map(Chick.init)
                chicks.appendContentsOf(newChicks)
                var hatchingIndexes = (0..<(eggs.count)).filter({i in eggs[i].hatchAt <= currentTime})
                hatchingIndexes = hatchingIndexes.reverse()
                hatchingIndexes.forEach({i in self.eggs.removeAtIndex(i)})
            }
        }
        
        for chick in chicks {
            chick.update()
        }
        
        (0..<(chicks.count))
            .filter({i in chicks[i].outOfBounds})
            .reverse()
            .forEach({i in chicks.removeAtIndex(i)})
    }
}
