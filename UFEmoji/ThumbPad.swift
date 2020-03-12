//
//  ThumbPad the Ultimate Precision Game Controller
//
//  by Todd Bruss 12/3/2015 - 12/26/2017
//

import SpriteKit

protocol ThumbPadProtocol {
    func ThumbPad(velocity: CGVector, zRotation: CGFloat)
}

class JoyPad: SKNode {
    var velocity = CGVector.zero
    var runtimeLoop: CADisplayLink?
    var anchor = CGPoint.zero
    let thumbNode: SKSpriteNode, backgroundNode: SKSpriteNode
    let thumbSpring: TimeInterval = 0.08
    let dampener = CGFloat(1)
    let play = CGFloat(2)
    let snapToPoint = CGFloat(16)
    var focus = false
    func setThumbImage(_ image: UIImage?, sizeToFit: Bool) {
        let img: UIImage = UIImage(named: "bg-stick")!
        thumbNode.texture = SKTexture(image: img)
        if sizeToFit {
            thumbNodeWidth = min(img.size.width, img.size.height)
        }
    }
    
    func backgroundImage(_ image: UIImage?, sizeToFit: Bool) {
        let img: UIImage = UIImage(named: "bg-joystick")!
        backgroundNode.texture = SKTexture(image: img)
        if sizeToFit {
            backgroundImageWidth = min(img.size.width, img.size.height)
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
        get { return (thumbNode.size.width / 2) }
    }
    
    var delagate: ThumbPadProtocol? {
        
        didSet {
            //runtimeLoop?.invalidate()
            //runtimeLoop = nil
            if delagate != nil {
                runtimeLoop = CADisplayLink(target: self, selector: #selector(JoyPad.update))
                runtimeLoop?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            }
        }
    }

    @objc func update() {
        if velocity == CGVector.zero && focus {
            
            delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * -0.003))
          
            focus = false
            
            let easeOut: SKAction = SKAction.move(to: anchor, duration: thumbSpring)
            easeOut.timingMode = SKActionTimingMode.easeOut
            thumbNode.run(easeOut)
            
        } else if velocity != CGVector.zero {
            if settings.level != 5 {
                delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * -0.003))
            } else {
                delagate?.ThumbPad(velocity: velocity, zRotation: CGFloat(velocity.dx * -0.006))

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
  
        /*
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat((backgroundImageWidth / 2) + play), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: circlePath.cgPath)
        backgroundNode.physicsBody?.collisionBitMask = 16384 + 16384;
        backgroundNode.physicsBody?.categoryBitMask = 16384
        backgroundNode.physicsBody?.contactTestBitMask = 0
        backgroundNode.physicsBody?.affectedByGravity = false;
        backgroundNode.physicsBody?.isDynamic = true;
        backgroundNode.physicsBody?.isResting = true;

        backgroundNode.physicsBody?.restitution = 0
        thumbNode.physicsBody?.fieldBitMask = 0
        */
        
        addChild(backgroundNode)
        backgroundNode.isUserInteractionEnabled = false;
        /*
        let thumbPath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(thumbNodeRadius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        thumbNode.physicsBody = SKPhysicsBody(edgeLoopFrom: thumbPath.cgPath)
        thumbNode.physicsBody?.collisionBitMask = 16384
        thumbNode.physicsBody?.categoryBitMask = 16384 + 16384
        thumbNode.physicsBody?.contactTestBitMask = 0
        thumbNode.physicsBody?.affectedByGravity = false;
        thumbNode.physicsBody?.isDynamic = true;
        thumbNode.physicsBody?.restitution = 0
        thumbNode.physicsBody?.fieldBitMask = 0
         */
        addChild(thumbNode)
        isUserInteractionEnabled = true;
        thumbNode.zPosition = 1000;
        thumbNode.isUserInteractionEnabled = false;


    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        if velocity != CGVector.zero && focus {
            velocity = CGVector.zero
        }
    }
    
    func stickMoved(location: CGPoint) {
        var floorX = floor(location.x)
        var floorY = floor(location.y)
       
        
        if floorY < -thumbNodeRadius {
            floorY = floor(-thumbNodeRadius)
            
            if floorX >= -snapToPoint && floorX <= snapToPoint {
                floorX = 0.0
            }
            
        } else if floorY > thumbNodeRadius {
            floorY = floor(thumbNodeRadius)
            
            if floorX >= -snapToPoint && floorX <= snapToPoint {
                floorX = 0.0
            }
        }
        
        if floorX < -thumbNodeRadius {
            floorX = floor(-thumbNodeRadius)
            
            if floorY >= -snapToPoint && floorY <= snapToPoint {
                floorY = 0.0
            }
        
        } else if floorX > thumbNodeRadius {
            floorX = floor(thumbNodeRadius)
            
            if floorY >= -snapToPoint && floorY <= snapToPoint {
                floorY = 0.0
            }
        }
    
        velocity = CGVector(dx: (floorX / dampener) / dampener, dy: (floorY / dampener)  / dampener )
        let moveToLocation = SKAction.move(to: CGPoint(x:floorX,y:floorY), duration: 0)
        thumbNode.run(moveToLocation)
    }
    

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches as Set<UITouch>, with: event);
        //for touch: AnyObject in touches {
    
        if let location = touches.first?.location(in: self) {
            if location !=  CGPoint.zero  {
                stickMoved(location: location)
            }
        }
    }
    
    // touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            if location !=  CGPoint.zero  {
                reset()
            }
        }
        
    }
    
}
