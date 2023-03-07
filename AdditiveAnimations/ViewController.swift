import Cocoa

class ViewController: NSViewController {

    var layer: CALayer!
    var item: CALayer!
    var isAnimating = false
        
    override func viewDidLoad() {
        view.wantsLayer = true
        layer = view.layer
        
        item = CALayer()
        item.anchorPoint = .zero
        item.borderColor = NSColor.red.cgColor
        item.borderWidth = 1
        item.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        layer.addSublayer(item)
                
        super.viewDidLoad()
    }
    
    @IBAction func togglePosition(_ sender: Any) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer { CATransaction.commit() }

        let oldP = item.position
        let newP: CGPoint = {
            if oldP == .zero {
                return .init(x: 100, y: 100)
            } else {
                return .zero
            }
        }()

        item.position = newP
        
        let negativeDifference = CGPoint(
            x: oldP.x - newP.x,
            y: oldP.y - newP.y
        )

        let animation = CASpringAnimation(keyPath: "position")
        animation.isAdditive = true
        animation.fromValue = negativeDifference
        animation.toValue   = CGPointZero
        animation.configure(response: 3, dampingRatio: 0.5)
        animation.delegate = self
        item.add(animation, forKey: nil)
    }

    @IBAction func toggleBounds(_ sender: Any) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer { CATransaction.commit() }

        let oldB = item.bounds
        let newB: CGRect = {
            if oldB == .init(x: 0, y: 0, width: 100, height: 100) {
                return .init(x: 0, y: 0, width: 400, height: 100)
            } else {
                return .init(x: 0, y: 0, width: 100, height: 100)
            }
        }()

        item.bounds = newB

        let negativeDifference = CGRect(
            x: oldB.minX - newB.minX,
            y: oldB.minY - newB.minY,
            width: oldB.width - newB.width,
            height: oldB.height - newB.height
        )

        let animation = CASpringAnimation(keyPath: "bounds")
        animation.isAdditive = true
        animation.fromValue = negativeDifference
        animation.toValue   = CGRectZero
        animation.configure(response: 3, dampingRatio: 0.5)
        animation.delegate = self
        item.add(animation, forKey: nil)
        
        isAnimating = true
        watchBounds()
    }
    
    func watchBounds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 / 16) {
            print("presentation bounds: \(self.item.presentation()!.bounds)")
            if self.isAnimating {
                self.watchBounds()
            }
        }
    }

}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("finished: \(flag), anim: \(anim)")
        isAnimating = false
    }
}
