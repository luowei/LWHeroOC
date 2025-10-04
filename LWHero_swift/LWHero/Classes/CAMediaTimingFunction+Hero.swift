//
//  CAMediaTimingFunction+Hero.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

extension CAMediaTimingFunction {
    // MARK: - Default Timing Functions

    public static var linear: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .linear)
    }

    public static var easeIn: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeIn)
    }

    public static var easeOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeOut)
    }

    public static var easeInOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeInEaseOut)
    }

    // MARK: - Material Design Timing Functions

    public static var standard: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    }

    public static var deceleration: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1.0)
    }

    public static var acceleration: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1.0, 1.0)
    }

    public static var sharp: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.6, 1.0)
    }

    // MARK: - Easing.net Timing Functions

    public static var easeOutBack: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
    }

    // MARK: - Factory Method

    public static func function(fromName name: String) -> CAMediaTimingFunction? {
        switch name.lowercased() {
        case "linear":
            return .linear
        case "easein":
            return .easeIn
        case "easeout":
            return .easeOut
        case "easeinout":
            return .easeInOut
        case "standard":
            return .standard
        case "deceleration":
            return .deceleration
        case "acceleration":
            return .acceleration
        case "sharp":
            return .sharp
        case "easeoutback":
            return .easeOutBack
        default:
            return nil
        }
    }
}
