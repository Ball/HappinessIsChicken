import Foundation

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
    func lay(eggs eggs:[Egg]) {
        var eggs = eggs
        eggs.append(Egg(momma:self))
        isLaying = false
    }
    func update(currentTime:CFTimeInterval) {
        if isStanding { return }
        if location == destination { isStanding = true; isLaying = true }
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
func distanceBetween(p1 p1: CGPoint, andP2 p2: CGPoint) -> CGFloat {
    let dy = (p1.y - p2.y)
    let dx = (p1.x - p2.x)
    return hypot(dy, dx)
}

class Egg {
    var location:CGPoint
    var facing:Facing
    var hatchAt: NSDate
    var hatched: Bool
    init(momma: Chicken) {
        location = momma.location
        facing = momma.facing
        hatchAt = NSDate().dateByAddingTimeInterval(NSTimeInterval(3))
        hatched = false
    }
}
class Chick {
    var location:CGPoint
    var facing:Facing
    init(egg:Egg){
        location = egg.location
        facing = egg.facing
    }
}

class Game {
    var chicken:Chicken
    var eggs:[Egg]
    var chicks:[Chick]
    init(){
        chicken = Chicken()
        eggs = []
        chicks = []
    }
    func update(currentTime currentTime: CFTimeInterval) {
        chicken.update(currentTime)
        if chicken.isLaying {
            chicken.lay(eggs: eggs)
        }
    }
}
