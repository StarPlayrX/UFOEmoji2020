//
//  GamePad ]|[ the Ultimate Touch Screen Precision Game Controller
//
//  by Todd Bruss (c) 2020
//

import SpriteKit

protocol ThumbPadProtocol {
    func TouchPad(velocity: CGVector, zRotation: CGFloat)
}

class JoyPad: SKNode {
    var velocity = CGVector.zero
    var runtimeLoop: CADisplayLink?
    var ease : TimeInterval = 0.04
    var anchor = CGPoint.zero
    let thumbNode: SKSpriteNode
    let backgroundNode: SKSpriteNode
    let thumbSpring: TimeInterval = 0.08
    let multiplier = CGFloat(10)
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
    
    var delegate: ThumbPadProtocol? {
        willSet {
            velocity = CGVector.zero
            recenter()
            runtimeLoop = CADisplayLink(target: self, selector: #selector(update))
            runtimeLoop?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }

    @objc func update() {
        
        delegate?.TouchPad(velocity: velocity, zRotation: CGFloat( velocity.dx / multiplier * dx ))
    
        if velocity != CGVector.zero {
            focus = true
        } else if focus {
            focus = false
            
            let easeOut: SKAction = SKAction.move(to: anchor, duration: thumbSpring)
            easeOut.timingMode = SKActionTimingMode.easeOut
            thumbNode.run(easeOut)
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
    

    //MARK: Stick Moved (After)
    func stickMoved(location: CGPoint) {
        
        //MARK: Clamp our max and min range of our joystick
        func clamp (_ f: CGFloat) -> CGFloat {
            min(max(f, -thumbNodeRadius), thumbNodeRadius)
        }
        
        //MARK: SnapToPoint (Up, Down, Left, Right)
        func snap (_ f: CGFloat, _ s: CGFloat ) -> CGFloat {
                f == -thumbNodeRadius || f == thumbNodeRadius
                    && -snapToPoint...snapToPoint ~= s
                    ? zero : s
        }
        
        //MARK: clampX and Y
        let clampX = clamp( floor(location.x) )
        let clampY = clamp( floor(location.y) )
        
        let snapY = snap( clampX, clampY )
        let snapX = snap( clampY, clampX )
        
        velocity = CGVector(dx: snapX * multiplier, dy: ( snapY * multiplier ) / two )
        
        let moveToLocation = SKAction.move(to: CGPoint( x: snapX,y: snapY ), duration: ease )
        moveToLocation.timingMode = .easeOut
        thumbNode.run( moveToLocation )
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
