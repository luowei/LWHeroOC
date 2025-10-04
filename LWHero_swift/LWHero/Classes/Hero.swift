//
//  Hero.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

public class Hero: NSObject {
    // MARK: - Singleton

    public static let shared = Hero()

    // MARK: - Properties

    public private(set) weak var toViewController: UIViewController?
    public private(set) weak var fromViewController: UIViewController?
    public private(set) var context: HeroContext?
    public private(set) var presenting = false
    public var interactive = false
    public private(set) var progress: CGFloat = 0
    public var transitioning = false
    public private(set) var container: UIView?
    public var forceNotInteractive = false

    private var transitionContainer: UIView?
    private var completionCallback: ((Bool) -> Void)?
    private var progressUpdateObservers: [HeroProgressUpdateObserver] = []
    private var animators: [HeroAnimator] = []
    private var preprocessors: [HeroPreprocessor] = []
    private var plugins: [HeroPlugin.Type] = []
    private var context_: HeroContext?
    private var animatingViewCount = 0
    private var totalDuration: TimeInterval = 0
    private var beginTime: TimeInterval?
    private var transitionContext: UIViewControllerContextTransitioning?

    // MARK: - Private Initialization

    private override init() {
        super.init()
        // Add default animator
        animators.append(HeroDefaultAnimator())
    }
}

// MARK: - Interactive Transition

extension Hero {
    public func update(progress: CGFloat) {
        guard transitioning else { return }
        self.progress = max(0, min(1, progress))

        for observer in progressUpdateObservers {
            observer.heroDidUpdateProgress(Double(self.progress))
        }

        let timePassed = TimeInterval(self.progress) * totalDuration

        for animator in animators {
            animator.seek(to: timePassed)
        }
    }

    public func end(animated: Bool = true) {
        guard transitioning else { return }

        if animated {
            let timePassed = TimeInterval(progress) * totalDuration
            var maxTime: TimeInterval = 0

            for animator in animators {
                let time = animator.resume(at: timePassed, reverse: false)
                maxTime = max(maxTime, time)
            }

            complete(after: maxTime, finishing: true)
        } else {
            complete(finishing: true)
        }
    }

    public func cancel(animated: Bool = true) {
        guard transitioning else { return }

        if animated {
            let timePassed = TimeInterval(progress) * totalDuration
            var maxTime: TimeInterval = 0

            for animator in animators {
                let time = animator.resume(at: timePassed, reverse: true)
                maxTime = max(maxTime, time)
            }

            complete(after: maxTime, finishing: false)
        } else {
            complete(finishing: false)
        }
    }

    public func apply(modifiers: [HeroModifier], to view: UIView) {
        guard let context = context else { return }
        let state = HeroTargetState(modifiers: modifiers)

        for animator in animators {
            animator.apply(state: state, to: view)
        }
    }
}

// MARK: - Observe

extension Hero {
    public func observe(forProgressUpdate observer: HeroProgressUpdateObserver) {
        if !progressUpdateObservers.contains(where: { $0 === observer }) {
            progressUpdateObservers.append(observer)
        }
    }
}

// MARK: - Transition

extension Hero {
    public func start() {
        guard let context = context,
              let fromView = fromViewController?.view,
              let toView = toViewController?.view else { return }

        // Process with preprocessors
        for preprocessor in preprocessors {
            preprocessor.process(fromViews: context.fromViews, toViews: context.toViews)
        }

        // Animate
        var totalDuration: TimeInterval = 0
        for animator in animators {
            let duration = animator.animate(fromViews: context.fromViews, toViews: context.toViews)
            totalDuration = max(totalDuration, duration)
        }

        self.totalDuration = totalDuration

        if !interactive {
            complete(after: totalDuration, finishing: true)
        }
    }

    public func transition(from: UIViewController,
                          to: UIViewController,
                          in view: UIView,
                          completion: ((Bool) -> Void)? = nil) {
        guard !transitioning else {
            completion?(false)
            return
        }

        transitioning = true
        fromViewController = from
        toViewController = to
        transitionContainer = view
        completionCallback = completion
        presenting = from.presentedViewController == to

        // Create container
        let container = UIView(frame: view.bounds)
        container.isUserInteractionEnabled = false
        self.container = container
        view.addSubview(container)

        // Create context
        context = HeroContext(container: container, fromView: from.view, toView: to.view)

        // Start transition
        start()
    }

    public func complete(after delay: TimeInterval, finishing: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.complete(finishing: finishing)
        }
    }

    public func complete(finishing: Bool) {
        guard transitioning else { return }

        // Clean up animators
        for animator in animators {
            animator.clean()
        }

        // Unhide all views
        context?.unhideAll()

        // Remove container
        container?.removeFromSuperview()
        container = nil

        transitioning = false
        progress = 0
        context = nil

        // Call completion
        completionCallback?(finishing)
        completionCallback = nil

        fromViewController = nil
        toViewController = nil
        transitionContainer = nil
    }
}

// MARK: - Delegate Helper

extension Hero {
    public func closureProcess(forHeroDelegate viewController: UIViewController,
                              closure: (HeroViewControllerDelegate) -> Void) {
        if let delegate = viewController as? HeroViewControllerDelegate {
            closure(delegate)
        }
    }
}

// MARK: - Plugin Support

extension Hero {
    public static func isEnabled(plugin: HeroPlugin.Type) -> Bool {
        return plugin.isEnabled()
    }

    public static func enable(plugin: HeroPlugin.Type) {
        plugin.enable()
    }

    public static func disable(plugin: HeroPlugin.Type) {
        plugin.disable()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension Hero: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let container = transitionContext.containerView

        self.transition(from: fromVC, to: toVC, in: container) { [weak self] finished in
            if !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(finished)
            } else {
                transitionContext.completeTransition(false)
            }
            self?.transitionContext = nil
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension Hero: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                   presenting: UIViewController,
                                   source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
}

// MARK: - UIViewControllerInteractiveTransitioning

extension Hero: UIViewControllerInteractiveTransitioning {
    public var wantsInteractiveStart: Bool {
        return interactive && !forceNotInteractive
    }

    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        animateTransition(using: transitionContext)
    }
}

// MARK: - UINavigationControllerDelegate

extension Hero: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                    animationControllerFor operation: UINavigationController.Operation,
                                    from fromVC: UIViewController,
                                    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = operation == .push
        return self
    }

    public func navigationController(_ navigationController: UINavigationController,
                                    interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
}

// MARK: - UITabBarControllerDelegate

extension Hero: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController,
                                animationControllerForTransitionFrom fromVC: UIViewController,
                                to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func tabBarController(_ tabBarController: UITabBarController,
                                interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
}
