//
//  IgnoreSubviewModifiersPreprocessor.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

public class IgnoreSubviewModifiersPreprocessor: BasePreprocessor {
    // MARK: - HeroPreprocessor

    public override func process(fromViews: [UIView], toViews: [UIView]) {
        guard let context = context else { return }

        let allViews = fromViews + toViews

        for view in allViews {
            guard let state = context.state(of: view),
                  let ignoreSubviewModifiers = state.ignoreSubviewModifiers,
                  ignoreSubviewModifiers else { continue }

            // Remove modifiers from subviews
            processSubviews(of: view, recursive: ignoreSubviewModifiers)
        }
    }

    private func processSubviews(of view: UIView, recursive: Bool) {
        guard let context = context else { return }

        for subview in view.subviews {
            // Clear modifiers
            context.setState(HeroTargetState(), for: subview)

            if recursive {
                processSubviews(of: subview, recursive: true)
            }
        }
    }
}
