import Cocoa

extension CALayer {
    
    func animate<Value>(for key: String, fromValue: Value, toValue: Value, response: CGFloat? = nil, dampingRatio: CGFloat? = nil) -> CABasicAnimation? where Value: Equatable {
        if let animation = animation(for: key, fromValue: fromValue, toValue: toValue, response: response, dampingRatio: dampingRatio) {
            add(animation, forKey: key)
            return animation
        }
        return nil
    }

    
    func animation<Value>(for key: String, fromValue: Value, toValue: Value, response: CGFloat? = nil, dampingRatio: CGFloat? = nil) -> CABasicAnimation? where Value: Equatable {
        setValue(toValue, forKey: key)
        
        if let animation = action(forKey: key) as? CABasicAnimation {
            animation.fromValue = fromValue
            animation.toValue = toValue
            
            if let animation = animation as? CASpringAnimation, let response = response, let dampingRatio = dampingRatio {
                animation.configure(response: response, dampingRatio: dampingRatio)
            }
            
            return animation
        }
        
        return nil
    }
    
    func additiveAnimation<Value>(for key: String, toValue: Value) -> CABasicAnimation? where Value: AdditiveArithmetic {
        guard let fromValue = presentation()?.value(forKey: key) as? Value else {
            return nil
        }
        
        setValue(toValue, forKey: key)

        let negativeDifference = fromValue - toValue

        guard negativeDifference != .zero, let animation = action(forKey: key) as? CABasicAnimation else {
            return nil
        }
        
        animation.isAdditive = true
        animation.fromValue = negativeDifference
        animation.toValue = CGPointZero

        //animation.configure(response: 3, dampingRatio: 0.5)
        //animation.delegate = self
        //each.add(animation, forKey: nil)

        
        return animation
    }
    
}

extension CASpringAnimation {
    
    public func configure(response: CGFloat, dampingRatio: CGFloat) {
        let response = response != 0 ? response : 0.0001
        let stiffness = pow(2.0 * .pi / response, 2.0)
        let damping = 4.0 * .pi * dampingRatio / response
        self.stiffness = stiffness
        self.damping = damping
        self.duration = settlingDuration
    }
    
}
