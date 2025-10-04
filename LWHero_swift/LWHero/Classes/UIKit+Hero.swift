//
//  UIKit+Hero.swift
//  LWHero
//
//  Created by Swift Port
//  Copyright © 2025. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

// MARK: - UIView + Hero

private var heroIDKey: UInt8 = 0
private var heroModifiersKey: UInt8 = 1
private var heroModifierStringKey: UInt8 = 2

extension UIView {
    @IBInspectable public var heroID: String? {
        get {
            return objc_getAssociatedObject(self, &heroIDKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &heroIDKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    public var heroModifiers: [HeroModifier]? {
        get {
            return objc_getAssociatedObject(self, &heroModifiersKey) as? [HeroModifier]
        }
        set {
            objc_setAssociatedObject(self, &heroModifiersKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @IBInspectable public var heroModifierString: String? {
        get {
            return objc_getAssociatedObject(self, &heroModifierStringKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &heroModifierStringKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if let newValue = newValue {
                heroModifiers = parseModifierString(newValue)
            } else {
                heroModifiers = nil
            }
        }
    }

    public func slowSnapshotView() -> UIView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        let imageView = UIImageView(image: image)
        imageView.frame = bounds

        return imageView
    }

    private func parseModifierString(_ string: String) -> [HeroModifier] {
        var modifiers: [HeroModifier] = []
        let components = string.components(separatedBy: " ")

        var i = 0
        while i < components.count {
            let name = components[i]
            var parameters: [String] = []

            i += 1
            while i < components.count && !components[i].hasSuffix(")") {
                let param = components[i].trimmingCharacters(in: CharacterSet(charactersIn: "(),"))
                if !param.isEmpty {
                    parameters.append(param)
                }
                i += 1
            }

            if i < components.count {
                let lastParam = components[i].trimmingCharacters(in: CharacterSet(charactersIn: "(),"))
                if !lastParam.isEmpty {
                    parameters.append(lastParam)
                }
                i += 1
            }

            if let modifier = HeroModifier.modifier(fromName: name, parameters: parameters) {
                modifiers.append(modifier)
            }
        }

        return modifiers
    }
}

// MARK: - UIViewController + Hero

private var previousNavigationDelegateKey: UInt8 = 10
private var previousTabBarDelegateKey: UInt8 = 11
private var isHeroEnabledKey: UInt8 = 12

extension UIViewController {
    public var previousNavigationDelegate: UINavigationControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &previousNavigationDelegateKey) as? UINavigationControllerDelegate
        }
        set {
            objc_setAssociatedObject(self, &previousNavigationDelegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public var previousTabBarDelegate: UITabBarControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &previousTabBarDelegateKey) as? UITabBarControllerDelegate
        }
        set {
            objc_setAssociatedObject(self, &previousTabBarDelegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    @IBInspectable public var isHeroEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &isHeroEnabledKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &isHeroEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                if let navigationController = navigationController {
                    previousNavigationDelegate = navigationController.delegate
                    navigationController.delegate = Hero.shared
                }

                if let tabBarController = tabBarController {
                    previousTabBarDelegate = tabBarController.delegate
                    tabBarController.delegate = Hero.shared
                }

                transitioningDelegate = Hero.shared
            } else {
                if let navigationController = navigationController,
                   navigationController.delegate === Hero.shared {
                    navigationController.delegate = previousNavigationDelegate
                }

                if let tabBarController = tabBarController,
                   tabBarController.delegate === Hero.shared {
                    tabBarController.delegate = previousTabBarDelegate
                }

                if transitioningDelegate === Hero.shared {
                    transitioningDelegate = nil
                }
            }
        }
    }

    @IBAction public func ht_dismiss(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }

    public func heroReplace(with next: UIViewController) {
        if let navigationController = navigationController {
            var viewControllers = navigationController.viewControllers
            if let index = viewControllers.firstIndex(of: self) {
                viewControllers[index] = next
                navigationController.setViewControllers(viewControllers, animated: false)
            }
        }
    }
}

// MARK: - Array Helper Extension

extension Array {
    func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    func getCGFloat(at index: Int) -> CGFloat? {
        guard let element = get(at: index) else { return nil }

        if let value = element as? CGFloat {
            return value
        } else if let value = element as? Double {
            return CGFloat(value)
        } else if let value = element as? Float {
            return CGFloat(value)
        } else if let value = element as? Int {
            return CGFloat(value)
        } else if let string = element as? String {
            return Double(string).map { CGFloat($0) }
        }

        return nil
    }

    func getDouble(at index: Int) -> Double? {
        guard let element = get(at: index) else { return nil }

        if let value = element as? Double {
            return value
        } else if let value = element as? CGFloat {
            return Double(value)
        } else if let value = element as? Float {
            return Double(value)
        } else if let value = element as? Int {
            return Double(value)
        } else if let string = element as? String {
            return Double(string)
        }

        return nil
    }

    func getBool(at index: Int) -> Bool? {
        guard let element = get(at: index) else { return nil }

        if let value = element as? Bool {
            return value
        } else if let string = element as? String {
            return string.lowercased() == "true" || string == "1"
        } else if let number = element as? NSNumber {
            return number.boolValue
        }

        return nil
    }
}
