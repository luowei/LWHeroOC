//
//  HeroContext.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit

public class HeroContext {
    // MARK: - Properties

    public var fromViews: [UIView] = []
    public var toViews: [UIView] = []
    public let container: UIView

    private var viewToStateMap: [UIView: HeroTargetState] = [:]
    private var viewToIDMap: [String: UIView] = [:]
    private var hiddenViews: [UIView] = []
    private var snapshotViews: [UIView: UIView] = [:]

    // MARK: - Initialization

    public init(container: UIView, fromView: UIView, toView: UIView) {
        self.container = container

        var fromIDMap: [String: UIView] = [:]
        var toIDMap: [String: UIView] = [:]
        var fromStateMap: [UIView: HeroTargetState] = [:]
        var toStateMap: [UIView: HeroTargetState] = [:]

        self.fromViews = HeroContext.processViewTree(
            view: fromView,
            container: container,
            idMap: &fromIDMap,
            stateMap: &fromStateMap
        )

        self.toViews = HeroContext.processViewTree(
            view: toView,
            container: container,
            idMap: &toIDMap,
            stateMap: &toStateMap
        )

        // Merge ID maps
        viewToIDMap = fromIDMap
        for (key, value) in toIDMap {
            viewToIDMap[key] = value
        }

        // Merge state maps
        viewToStateMap = fromStateMap
        for (key, value) in toStateMap {
            viewToStateMap[key] = value
        }
    }

    // MARK: - View Processing

    public static func processViewTree(
        view: UIView,
        container: UIView,
        idMap: inout [String: UIView],
        stateMap: inout [UIView: HeroTargetState]
    ) -> [UIView] {
        var views: [UIView] = []

        if let heroID = view.heroID {
            idMap[heroID] = view
        }

        if let modifiers = view.heroModifiers {
            stateMap[view] = HeroTargetState(modifiers: modifiers)
        }

        views.append(view)

        for subview in view.subviews {
            views.append(contentsOf: processViewTree(
                view: subview,
                container: container,
                idMap: &idMap,
                stateMap: &stateMap
            ))
        }

        return views
    }

    // MARK: - View Queries

    public func sourceView(forHeroID heroID: String) -> UIView? {
        for view in fromViews {
            if view.heroID == heroID {
                return view
            }
        }
        return nil
    }

    public func destinationView(forHeroID heroID: String) -> UIView? {
        for view in toViews {
            if view.heroID == heroID {
                return view
            }
        }
        return nil
    }

    public func pairedView(for view: UIView) -> UIView? {
        guard let heroID = view.heroID else { return nil }

        if fromViews.contains(view) {
            return destinationView(forHeroID: heroID)
        } else if toViews.contains(view) {
            return sourceView(forHeroID: heroID)
        }

        return nil
    }

    // MARK: - Snapshot Management

    public func snapshotView(for view: UIView) -> UIView {
        if let snapshot = snapshotViews[view] {
            return snapshot
        }

        let snapshot = view.slowSnapshotView()
        snapshotViews[view] = snapshot
        return snapshot
    }

    // MARK: - View Visibility

    public func hide(_ view: UIView) {
        if !hiddenViews.contains(view) {
            hiddenViews.append(view)
            view.isHidden = true
        }
    }

    public func unhide(_ view: UIView) {
        if let index = hiddenViews.firstIndex(of: view) {
            hiddenViews.remove(at: index)
            view.isHidden = false
        }
    }

    public func unhideAll() {
        for view in hiddenViews {
            view.isHidden = false
        }
        hiddenViews.removeAll()
    }

    // MARK: - Target State Management

    public func state(of view: UIView) -> HeroTargetState? {
        return viewToStateMap[view]
    }

    public func setState(_ state: HeroTargetState, for view: UIView) {
        viewToStateMap[view] = state
    }
}
