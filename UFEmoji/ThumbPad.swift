//
//  Joy | Thumb Pad ][ the Ultimate Precision Game Controller
//
//  by Todd Bruss 12/3/2015 - 5/17/2020
//

import SpriteKit

protocol ThumbPadProtocol {
    func ThumbPad(velocity: CGVector, zRotation: CGFloat)
}

class JoyPad: SKNode {
    var velocity = CGVector.zero
    var runtimeLoop: CADisplayLink?
    var anchor = CGPoint.zero
    let thumbNode: SKSpriteNode
    let backgroundNode: SKSpriteNode
    let thumbSpring: TimeInterval = 0.08
    let dampener = CGFloat(1)
    let dx = CGFloat(-0.003)
    let play = CGFloat(2)
    let zindex = CGFloat(1000)
    let snapToPoint = CGFloat(16)
    let zero = CGFloat(0.0)
    let two = CGFloat(2.0)
    
    var focus = false
    
    func setThumbImage(_ image: UIImage?, sizeToFit: Bool) {
        if let img: UIImage = UIImage(named: "bg-stick") {
            thumbNode.texture = SKTexture(image: img)
            if sizeToFit {
                thumbNodeWidth = min(img.size.width, img.size.height)
            }
        }
    }
    
    func backgroundImage(_ image: UIImage?, sizeToFit: Bool) {
        if let img: UIImage = UIImage(named: "bg-joystick") {
            backgroundNode.texture = SKTexture(image: img)
            if sizeToFit {
                backgroundImageWidth = min(img.size.width, img.size.height)
            }
        }
    }
    
    var backgroundImageWidth: CGFloat {
        get { return backgroundNode.size.width }
        set { backgroundNode.size = CGSize(width: newValue, height: newValue) }
    }
    
    var thumbNodeWidth: CGFloat {
        get { return thumbNode.size.width }
        set { thumbNode.size = CGSize(width: newValue, height: newValue) }
    }
    
    var thumbNodeRadius: CGFloat {
        get { return (thumbNode.size.width / two) }
    }
    
    var delagate: ThumbPadProtocol? {
        didSet {
            if let _ = delagate {
                runtimeLoop = CADisplayLink(target: self, selector: #selector(update))
                runtimeLoop?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            }
        }
    }

    @objc func update() {
        if velocity == CGVector.zero && focus {

            delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * dx))
          
            focus = false
            
            let easeOut: SKAction = SKAction.move(to: anchor, duration: thumbSpring)
            easeOut.timingMode = SKActionTimingMode.easeOut
            thumbNode.run(easeOut)
            
        } else if velocity != CGVector.zero {
            if settings.level != 5 {
                delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * dx))
            } else {
                delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * (dx * two) ))

            }
            focus = true
        }
    }
    
    convenience init(thumbImage: UIImage?) {
        self.init(thumbImage: thumbImage, bgImage: nil)
    }
    
    convenience init(bgImage: UIImage?) {
        self.init(thumbImage: nil, bgImage: bgImage)
    }
    
    convenience override init() {
        self.init(thumbImage: nil, bgImage: nil)
    }
    
    init(thumbImage: UIImage?, bgImage: UIImage?) {
        thumbNode = SKSpriteNode()
        backgroundNode = SKSpriteNode()
        
        super.init()
        
        setThumbImage(thumbImage, sizeToFit: true)
        backgroundImage(bgImage, sizeToFit: true)
        velocity = CGVector.zero
  
        addChild(backgroundNode)
        
        backgroundNode.isUserInteractionEnabled = false
        
        addChild(thumbNode)
        
        isUserInteractionEnabled = true
        thumbNode.zPosition = zindex
        thumbNode.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: recenter to zero
    func recenter() {
        if velocity != CGVector.zero && focus {
            velocity = CGVector.zero
        }
    }
    
    //MARK: Stick Moved
    func stickMoved(location: CGPoint) {
        var floorX = floor(location.x)
        var floorY = floor(location.y)
       
        
        if floorY < -thumbNodeRadius {
            floorY = floor(-thumbNodeRadius)
            
            if floorX >= -snapToPoint && floorX <= snapToPoint {
                floorX = zero
            }
            
        } else if floorY > thumbNodeRadius {
            floorY = floor(thumbNodeRadius)
            
            if floorX >= -snapToPoint && floorX <= snapToPoint {
                floorX = zero
            }
        }
        
        if floorX < -thumbNodeRadius {
            floorX = floor(-thumbNodeRadius)
            
            if floorY >= -snapToPoint && floorY <= snapToPoint {
                floorY = zero
            }
        
        } else if floorX > thumbNodeRadius {
            floorX = floor(thumbNodeRadius)
            
            if floorY >= -snapToPoint && floorY <= snapToPoint {
                floorY = zero
            }
        }
    
        velocity = CGVector(dx: (floorX / dampener) / dampener, dy: (floorY / dampener)  / dampener )
        let moveToLocation = SKAction.move(to: CGPoint(x:floorX,y:floorY), duration: 0)
        thumbNode.run(moveToLocation)
    }
    
    //MARK: Touches moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches as Set<UITouch>, with: event)
    
        if let location = touches.first?.location(in: self) {
            if location != CGPoint.zero  {
                stickMoved(location: location)
            }
        }
    }
    
    //MARK: Touches ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            if location != CGPoint.zero  {
                recenter()
            }
        }
    }
}
