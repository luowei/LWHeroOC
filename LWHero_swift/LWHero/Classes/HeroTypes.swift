//
//  HeroTypes.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

// MARK: - HeroPreprocessor Protocol

public protocol HeroPreprocessor {
    func process(fromViews: [UIView], toViews: [UIView])
}

// MARK: - HeroAnimator Protocol

public protocol HeroAnimator {
    func canAnimate(view: UIView, appearing: Bool) -> Bool
    func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval
    func clean()

    func seek(to timePassed: TimeInterval)
    func resume(at timePassed: TimeInterval, reverse: Bool) -> TimeInterval
    func apply(state: HeroTargetState, to view: UIView)
}

// MARK: - HeroProgressUpdateObserver Protocol

public protocol HeroProgressUpdateObserver: AnyObject {
    func heroDidUpdateProgress(_ progress: Double)
}

// MARK: - HeroViewControllerDelegate Protocol

@objc public protocol HeroViewControllerDelegate: AnyObject {
    @objc optional func heroWillStartAnimating(from viewController: UIViewController)
    @objc optional func heroDidEndAnimating(from viewController: UIViewController)
    @objc optional func heroWillStartTransition()
    @objc optional func heroDidEndTransition()
    @objc optional func heroWillStartAnimating(to viewController: UIViewController)
    @objc optional func heroDidEndAnimating(to viewController: UIViewController)
}
