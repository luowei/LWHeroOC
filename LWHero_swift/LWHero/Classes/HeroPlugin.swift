//
//  HeroPlugin.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

open class HeroPlugin: NSObject, HeroPreprocessor, HeroAnimator {
    // MARK: - Properties

    public var requirePerFrameCallback: Bool = false
    public private(set) var context: HeroContext?

    // MARK: - Initialization

    public override init() {
        super.init()
    }

    // MARK: - HeroPreprocessor

    open func process(fromViews: [UIView], toViews: [UIView]) {
        // Override in subclass
    }

    // MARK: - HeroAnimator

    open func canAnimate(view: UIView, appearing: Bool) -> Bool {
        // Override in subclass
        return false
    }

    open func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval {
        // Override in subclass
        return 0
    }

    open func clean() {
        // Override in subclass
    }

    open func seek(to timePassed: TimeInterval) {
        // Override in subclass
    }

    open func resume(at timePassed: TimeInterval, reverse: Bool) -> TimeInterval {
        // Override in subclass
        return 0
    }

    open func apply(state: HeroTargetState, to view: UIView) {
        // Override in subclass
    }
}

// MARK: - State Control

private var enabledPlugins: [String: Bool] = [:]

extension HeroPlugin {
    public static func isEnabled() -> Bool {
        let key = String(describing: self)
        return enabledPlugins[key] ?? false
    }

    public static func setEnabled(_ enabled: Bool) {
        let key = String(describing: self)
        enabledPlugins[key] = enabled
    }

    public static func enable() {
        setEnabled(true)
    }

    public static func disable() {
        setEnabled(false)
    }
}
