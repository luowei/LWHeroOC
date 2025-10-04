//
//  CascadePreprocessor.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CascadeDirection Enum

public enum CascadeDirection {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case radial(center: CGPoint)
    case inverseRadial(center: CGPoint)

    init?(string: String, center: CGPoint?) {
        switch string.lowercased() {
        case "toptobottom":
            self = .topToBottom
        case "bottomtotop":
            self = .bottomToTop
        case "lefttoright":
            self = .leftToRight
        case "righttoleft":
            self = .rightToLeft
        case "radial":
            guard let center = center else { return nil }
            self = .radial(center: center)
        case "inverseradial":
            guard let center = center else { return nil }
            self = .inverseRadial(center: center)
        default:
            return nil
        }
    }
}

// MARK: - CascadePreprocessor

public class CascadePreprocessor: BasePreprocessor {
    // MARK: - Properties

    private let direction: CascadeDirection

    // MARK: - Initialization

    public init(direction: CascadeDirection) {
        self.direction = direction
        super.init()
    }

    public convenience init?(directionString: String, center: CGPoint? = nil) {
        guard let direction = CascadeDirection(string: directionString, center: center) else {
            return nil
        }
        self.init(direction: direction)
    }

    // MARK: - HeroPreprocessor

    public override func process(fromViews: [UIView], toViews: [UIView]) {
        guard let context = context else { return }

        let allViews = fromViews + toViews

        for view in allViews {
            guard let state = context.state(of: view),
                  let cascade = state.cascade else { continue }

            let (delta, cascadeDirection, delayMatchedViews) = cascade

            // Get subviews to cascade
            var subviews = view.subviews

            // Sort subviews based on direction
            subviews = sortViews(subviews, direction: cascadeDirection)

            // Apply cascading delays
            for (index, subview) in subviews.enumerated() {
                if var subviewState = context.state(of: subview) {
                    let additionalDelay = Double(index) * delta
                    let currentDelay = subviewState.delay ?? 0
                    subviewState.delay = currentDelay + additionalDelay
                    context.setState(subviewState, for: subview)
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func sortViews(_ views: [UIView], direction: CascadeDirection) -> [UIView] {
        return views.sorted { (view1, view2) -> Bool in
            let center1 = view1.center
            let center2 = view2.center

            switch direction {
            case .topToBottom:
                return center1.y < center2.y

            case .bottomToTop:
                return center1.y > center2.y

            case .leftToRight:
                return center1.x < center2.x

            case .rightToLeft:
                return center1.x > center2.x

            case .radial(let center):
                let distance1 = distanceSquared(from: center1, to: center)
                let distance2 = distanceSquared(from: center2, to: center)
                return distance1 < distance2

            case .inverseRadial(let center):
                let distance1 = distanceSquared(from: center1, to: center)
                let distance2 = distanceSquared(from: center2, to: center)
                return distance1 > distance2
            }
        }
    }

    private func distanceSquared(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return dx * dx + dy * dy
    }
}
