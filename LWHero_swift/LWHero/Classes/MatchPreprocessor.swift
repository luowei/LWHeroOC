//
//  MatchPreprocessor.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

public class MatchPreprocessor: BasePreprocessor {
    // MARK: - HeroPreprocessor

    public override func process(fromViews: [UIView], toViews: [UIView]) {
        guard let context = context else { return }

        // Match views with same heroID
        for fromView in fromViews {
            if let heroID = fromView.heroID,
               let toView = context.destinationView(forHeroID: heroID) {
                // Apply matched state
                if var fromState = context.state(of: fromView) {
                    fromState.position = toView.center
                    fromState.size = toView.bounds.size
                    context.setState(fromState, for: fromView)
                }

                if var toState = context.state(of: toView) {
                    toState.position = fromView.center
                    toState.size = fromView.bounds.size
                    context.setState(toState, for: toView)
                }
            }
        }
    }
}
