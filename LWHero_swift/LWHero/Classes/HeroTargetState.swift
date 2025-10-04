//
//  HeroTargetState.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public class HeroTargetState: NSObject, NSCopying {
    // MARK: - Properties

    public var opacity: CGFloat?
    public var cornerRadius: CGFloat?
    public var position: CGPoint?
    public var size: CGSize?
    public var transform: CATransform3D?
    public var spring: (stiffness: CGFloat, damping: CGFloat)?
    public var delay: TimeInterval?
    public var duration: TimeInterval?
    public var timingFunction: CAMediaTimingFunction?
    public var arc: CGFloat?
    public var zPosition: CGFloat?
    public var zPositionIfMatched: CGFloat?
    public var source: String?
    public var cascade: (delta: TimeInterval, direction: CascadeDirection, delayMatchedViews: Bool)?
    public var useGlobalCoordinateSpace: Bool = false
    public var ignoreSubviewModifiers: Bool?

    public private(set) var custom: [[String: Any]] = []

    // MARK: - Initialization

    public override init() {
        super.init()
    }

    public init(modifiers: [HeroModifier]) {
        super.init()
        append(modifiers: modifiers)
    }

    // MARK: - Modifier Management

    public func append(modifiers: [HeroModifier]) {
        for modifier in modifiers {
            modifier.apply(self)
        }
    }

    // MARK: - Custom Items

    public func customItem(forKey key: String) -> Any? {
        for dict in custom {
            if let value = dict[key] {
                return value
            }
        }
        return nil
    }

    public func setCustomItem(_ value: Any?, forKey key: String) {
        if let value = value {
            var found = false
            for (index, dict) in custom.enumerated() {
                if dict[key] != nil {
                    custom[index][key] = value
                    found = true
                    break
                }
            }
            if !found {
                custom.append([key: value])
            }
        } else {
            custom = custom.map { dict in
                var mutableDict = dict
                mutableDict.removeValue(forKey: key)
                return mutableDict
            }.filter { !$0.isEmpty }
        }
    }

    // MARK: - NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = HeroTargetState()
        copy.opacity = opacity
        copy.cornerRadius = cornerRadius
        copy.position = position
        copy.size = size
        copy.transform = transform
        copy.spring = spring
        copy.delay = delay
        copy.duration = duration
        copy.timingFunction = timingFunction
        copy.arc = arc
        copy.zPosition = zPosition
        copy.zPositionIfMatched = zPositionIfMatched
        copy.source = source
        copy.cascade = cascade
        copy.useGlobalCoordinateSpace = useGlobalCoordinateSpace
        copy.ignoreSubviewModifiers = ignoreSubviewModifiers
        copy.custom = custom
        return copy
    }
}

// MARK: - Array Literal

extension HeroTargetState: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: HeroModifier...) {
        self.init(modifiers: elements)
    }
}
