//
//  HeroDefaultAnimator.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public class HeroDefaultAnimator: NSObject, HeroAnimator {
    // MARK: - Properties

    public private(set) var context: HeroContext?
    private var animatingViews: [UIView] = []
    private var viewContexts: [UIView: HeroDefaultAnimatorViewContext] = [:]

    // MARK: - HeroAnimator

    public func canAnimate(view: UIView, appearing: Bool) -> Bool {
        guard let context = context else { return false }
        guard let state = context.state(of: view) else { return false }

        // Check if there are any modifiers that we can animate
        return state.position != nil ||
               state.size != nil ||
               state.transform != nil ||
               state.opacity != nil ||
               state.cornerRadius != nil
    }

    public func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval {
        var maxDuration: TimeInterval = 0

        // Animate appearing views
        for view in toViews {
            if let state = context?.state(of: view) {
                let duration = animate(view: view, state: state, appearing: true)
                maxDuration = max(maxDuration, duration)
            }
        }

        // Animate disappearing views
        for view in fromViews {
            if let state = context?.state(of: view) {
                let duration = animate(view: view, state: state, appearing: false)
                maxDuration = max(maxDuration, duration)
            }
        }

        return maxDuration
    }

    private func animate(view: UIView, state: HeroTargetState, appearing: Bool) -> TimeInterval {
        let viewContext = HeroDefaultAnimatorViewContext(view: view, state: state, appearing: appearing)
        viewContexts[view] = viewContext

        let duration = state.duration ?? 0.3
        let delay = state.delay ?? 0

        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            viewContext.apply()
        }, completion: nil)

        return duration + delay
    }

    public func clean() {
        viewContexts.removeAll()
        animatingViews.removeAll()
    }

    public func seek(to timePassed: TimeInterval) {
        // Interactive animation support
        for (view, viewContext) in viewContexts {
            viewContext.seek(to: timePassed)
        }
    }

    public func resume(at timePassed: TimeInterval, reverse: Bool) -> TimeInterval {
        var maxDuration: TimeInterval = 0

        for (view, viewContext) in viewContexts {
            let duration = viewContext.resume(at: timePassed, reverse: reverse)
            maxDuration = max(maxDuration, duration)
        }

        return maxDuration
    }

    public func apply(state: HeroTargetState, to view: UIView) {
        if let viewContext = viewContexts[view] {
            viewContext.updateState(state)
            viewContext.apply()
        }
    }
}

// MARK: - HeroDefaultAnimatorViewContext

class HeroDefaultAnimatorViewContext {
    let view: UIView
    var state: HeroTargetState
    let appearing: Bool

    private var initialState: HeroTargetState

    init(view: UIView, state: HeroTargetState, appearing: Bool) {
        self.view = view
        self.state = state
        self.appearing = appearing

        // Capture initial state
        self.initialState = HeroTargetState()
        initialState.position = view.center
        initialState.size = view.bounds.size
        initialState.transform = view.layer.transform
        initialState.opacity = CGFloat(view.layer.opacity)
        initialState.cornerRadius = view.layer.cornerRadius
    }

    func apply() {
        if let position = state.position {
            view.center = position
        }

        if let size = state.size {
            view.bounds.size = size
        }

        if let transform = state.transform {
            view.layer.transform = transform
        }

        if let opacity = state.opacity {
            view.layer.opacity = Float(opacity)
        }

        if let cornerRadius = state.cornerRadius {
            view.layer.cornerRadius = cornerRadius
        }
    }

    func updateState(_ newState: HeroTargetState) {
        self.state = newState
    }

    func seek(to timePassed: TimeInterval) {
        // Simplified seek implementation
        let progress = calculateProgress(timePassed: timePassed)
        applyInterpolation(progress: progress)
    }

    func resume(at timePassed: TimeInterval, reverse: Bool) -> TimeInterval {
        let remainingDuration = (state.duration ?? 0.3) - timePassed
        return max(0, remainingDuration)
    }

    private func calculateProgress(timePassed: TimeInterval) -> CGFloat {
        let duration = state.duration ?? 0.3
        let delay = state.delay ?? 0

        if timePassed < delay {
            return 0
        }

        let adjustedTime = timePassed - delay
        return CGFloat(min(1.0, adjustedTime / duration))
    }

    private func applyInterpolation(progress: CGFloat) {
        if let targetPosition = state.position,
           let initialPosition = initialState.position {
            let x = initialPosition.x + (targetPosition.x - initialPosition.x) * progress
            let y = initialPosition.y + (targetPosition.y - initialPosition.y) * progress
            view.center = CGPoint(x: x, y: y)
        }

        if let targetSize = state.size,
           let initialSize = initialState.size {
            let width = initialSize.width + (targetSize.width - initialSize.width) * progress
            let height = initialSize.height + (targetSize.height - initialSize.height) * progress
            view.bounds.size = CGSize(width: width, height: height)
        }

        if let targetOpacity = state.opacity,
           let initialOpacity = initialState.opacity {
            let opacity = initialOpacity + (targetOpacity - initialOpacity) * progress
            view.layer.opacity = Float(opacity)
        }

        if let targetCornerRadius = state.cornerRadius,
           let initialCornerRadius = initialState.cornerRadius {
            let cornerRadius = initialCornerRadius + (targetCornerRadius - initialCornerRadius) * progress
            view.layer.cornerRadius = cornerRadius
        }
    }
}
