//
//  HeroModifier.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

// MARK: - HeroModifier

public class HeroModifier: NSObject {
    // MARK: - Properties

    public let apply: (HeroTargetState) -> Void

    // MARK: - Initialization

    public init(applyFunction: @escaping (HeroTargetState) -> Void) {
        self.apply = applyFunction
        super.init()
    }
}

// MARK: - Basic Modifiers

extension HeroModifier {
    public static var fade: HeroModifier {
        return HeroModifier { targetState in
            targetState.opacity = 0
        }
    }

    public static func position(_ position: CGPoint) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.position = position
        }
    }

    public static func size(_ size: CGSize) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.size = size
        }
    }
}

// MARK: - Transform Modifiers

extension HeroModifier {
    public static func transform(_ transform: CATransform3D) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.transform = transform
        }
    }

    public static func perspective(_ perspective: CGFloat) -> HeroModifier {
        return HeroModifier { targetState in
            var transform = targetState.transform ?? CATransform3DIdentity
            transform.m34 = 1.0 / -perspective
            targetState.transform = transform
        }
    }

    public static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> HeroModifier {
        return HeroModifier { targetState in
            let scale = CATransform3DMakeScale(x, y, z)
            targetState.transform = CATransform3DConcat(targetState.transform ?? CATransform3DIdentity, scale)
        }
    }

    public static func scale(_ xy: CGFloat) -> HeroModifier {
        return scale(x: xy, y: xy, z: 1)
    }

    public static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> HeroModifier {
        return HeroModifier { targetState in
            let translate = CATransform3DMakeTranslation(x, y, z)
            targetState.transform = CATransform3DConcat(targetState.transform ?? CATransform3DIdentity, translate)
        }
    }

    public static func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> HeroModifier {
        return HeroModifier { targetState in
            var rotation = targetState.transform ?? CATransform3DIdentity
            if x != 0 {
                rotation = CATransform3DRotate(rotation, x, 1, 0, 0)
            }
            if y != 0 {
                rotation = CATransform3DRotate(rotation, y, 0, 1, 0)
            }
            if z != 0 {
                rotation = CATransform3DRotate(rotation, z, 0, 0, 1)
            }
            targetState.transform = rotation
        }
    }

    public static func rotate(_ z: CGFloat) -> HeroModifier {
        return rotate(x: 0, y: 0, z: z)
    }
}

// MARK: - Timing Modifiers

extension HeroModifier {
    public static func duration(_ duration: TimeInterval) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.duration = duration
        }
    }

    public static func delay(_ delay: TimeInterval) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.delay = delay
        }
    }

    public static func timingFunction(_ timingFunction: CAMediaTimingFunction) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.timingFunction = timingFunction
        }
    }

    @available(iOS 9.0, *)
    public static func spring(stiffness: CGFloat, damping: CGFloat) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.spring = (stiffness, damping)
        }
    }
}

// MARK: - Other Modifiers

extension HeroModifier {
    public var ignoreSubviewModifiers: HeroModifier {
        return HeroModifier.ignoreSubviewModifiers(recursive: false)
    }

    public static func ignoreSubviewModifiers(recursive: Bool = false) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.ignoreSubviewModifiers = recursive
        }
    }

    public var arc: HeroModifier {
        return HeroModifier.arc(intensity: 1)
    }

    public static func arc(intensity: CGFloat = 1) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.arc = intensity
        }
    }

    public var cascade: HeroModifier {
        return HeroModifier.cascade()
    }

    public static func cascade(delta: TimeInterval = 0.02,
                              direction: CascadeDirection = .topToBottom,
                              delayMatchedViews: Bool = false) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.cascade = (delta, direction, delayMatchedViews)
        }
    }

    public static func zPosition(_ zPosition: CGFloat) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.zPosition = zPosition
        }
    }

    public static func zPositionIfMatched(_ zPosition: CGFloat) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.zPositionIfMatched = zPosition
        }
    }

    public static func source(_ heroID: String) -> HeroModifier {
        return HeroModifier { targetState in
            targetState.source = heroID
            targetState.useGlobalCoordinateSpace = true
        }
    }

    public static var useGlobalCoordinateSpace: HeroModifier {
        return HeroModifier { targetState in
            targetState.useGlobalCoordinateSpace = true
        }
    }
}

// MARK: - String Parsing

extension HeroModifier {
    public static func modifier(fromName name: String, parameters: [String]) -> HeroModifier? {
        let lowerName = name.lowercased()

        switch lowerName {
        case "fade":
            return .fade

        case "position":
            guard parameters.count >= 2,
                  let x = Double(parameters[0]),
                  let y = Double(parameters[1]) else { return nil }
            return .position(CGPoint(x: x, y: y))

        case "size":
            guard parameters.count >= 2,
                  let width = Double(parameters[0]),
                  let height = Double(parameters[1]) else { return nil }
            return .size(CGSize(width: width, height: height))

        case "scale":
            if parameters.count >= 3 {
                guard let x = Double(parameters[0]),
                      let y = Double(parameters[1]),
                      let z = Double(parameters[2]) else { return nil }
                return .scale(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
            } else if parameters.count >= 1 {
                guard let xy = Double(parameters[0]) else { return nil }
                return .scale(CGFloat(xy))
            }

        case "translate":
            guard parameters.count >= 2,
                  let x = Double(parameters[0]),
                  let y = Double(parameters[1]) else { return nil }
            let z = parameters.count >= 3 ? (Double(parameters[2]) ?? 0) : 0
            return .translate(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))

        case "rotate":
            if parameters.count >= 3 {
                guard let x = Double(parameters[0]),
                      let y = Double(parameters[1]),
                      let z = Double(parameters[2]) else { return nil }
                return .rotate(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
            } else if parameters.count >= 1 {
                guard let z = Double(parameters[0]) else { return nil }
                return .rotate(CGFloat(z))
            }

        case "duration":
            guard parameters.count >= 1,
                  let duration = Double(parameters[0]) else { return nil }
            return .duration(duration)

        case "delay":
            guard parameters.count >= 1,
                  let delay = Double(parameters[0]) else { return nil }
            return .delay(delay)

        case "spring":
            guard parameters.count >= 2,
                  let stiffness = Double(parameters[0]),
                  let damping = Double(parameters[1]) else { return nil }
            if #available(iOS 9.0, *) {
                return .spring(stiffness: CGFloat(stiffness), damping: CGFloat(damping))
            }

        case "arc":
            let intensity = parameters.count >= 1 ? (Double(parameters[0]) ?? 1) : 1
            return .arc(intensity: CGFloat(intensity))

        case "cascade":
            let delta = parameters.count >= 1 ? (Double(parameters[0]) ?? 0.02) : 0.02
            // For simplicity, default to topToBottom
            return .cascade(delta: delta, direction: .topToBottom, delayMatchedViews: false)

        case "zposition":
            guard parameters.count >= 1,
                  let zPos = Double(parameters[0]) else { return nil }
            return .zPosition(CGFloat(zPos))

        case "source":
            guard parameters.count >= 1 else { return nil }
            return .source(parameters[0])

        case "useglobalcoordinatespace":
            return .useGlobalCoordinateSpace

        case "ignoresubviewmodifiers":
            let recursive = parameters.count >= 1 ? (parameters[0].lowercased() == "true") : false
            return .ignoreSubviewModifiers(recursive: recursive)

        default:
            return nil
        }

        return nil
    }
}
