//
//  CardBehaviour.swift
//  PlayingCard
//
//  Created by 17 on 10/9/19.
//  Copyright © 2019 Ruben. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior()
        behaviour.translatesReferenceBoundsIntoBoundary = true
        return behaviour
    }()
    
    lazy var itemBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior()
        behaviour.allowsRotation = false
        behaviour.elasticity = 1
        behaviour.resistance = 0
        return behaviour
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2).arc4random
            default:
                push.angle = (CGFloat.pi*2).arc4random
            }
        }
        push.angle = (2 * CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehaviour.addItem(item)
        itemBehaviour.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehaviour.removeItem(item)
        itemBehaviour.removeItem(item)
        push(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehaviour)
        addChildBehavior(itemBehaviour)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
