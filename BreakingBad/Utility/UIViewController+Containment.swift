//
//  UIViewController+Containment.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 7.03.21.
//

import UIKit

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, to containerView: UIView) {
        addChild(child)

        containerView.frame = view.frame

        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
