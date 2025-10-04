//
//  SourcePreprocessor.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

public class SourcePreprocessor: BasePreprocessor {
    // MARK: - HeroPreprocessor

    public override func process(fromViews: [UIView], toViews: [UIView]) {
        guard let context = context else { return }

        for view in toViews {
            guard let state = context.state(of: view),
                  let sourceHeroID = state.source else { continue }

            if let sourceView = context.sourceView(forHeroID: sourceHeroID) {
                var updatedState = state
                updatedState.position = sourceView.center
                updatedState.size = sourceView.bounds.size
                updatedState.transform = sourceView.layer.transform
                updatedState.opacity = CGFloat(sourceView.layer.opacity)
                updatedState.cornerRadius = sourceView.layer.cornerRadius
                context.setState(updatedState, for: view)
            }
        }
    }
}
