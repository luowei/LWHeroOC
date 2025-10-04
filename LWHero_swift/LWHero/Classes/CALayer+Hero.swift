//
//  CALayer+Hero.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import QuartzCore

extension CALayer {
    public var animations: [[String: CAAnimation]] {
        var result: [[String: CAAnimation]] = []

        if let keys = animationKeys() {
            for key in keys {
                if let animation = animation(forKey: key) {
                    result.append([key: animation])
                }
            }
        }

        return result
    }
}
