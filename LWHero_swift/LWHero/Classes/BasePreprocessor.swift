//
//  BasePreprocessor.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

open class BasePreprocessor: NSObject, HeroPreprocessor {
    // MARK: - Properties

    public private(set) var context: HeroContext?

    // MARK: - Initialization

    public override init() {
        super.init()
    }

    // MARK: - HeroPreprocessor

    open func process(fromViews: [UIView], toViews: [UIView]) {
        // Override in subclass
    }
}
