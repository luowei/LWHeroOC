# LWHero Swift版本使用指南

## 概述

LWHero 是 LWHeroOC 的 Swift 实现版本，提供了优雅的视图控制器转场动画，类似于 Keynote 的神奇移动效果。

## 安装

### CocoaPods

在你的 Podfile 中添加：

```ruby
pod 'LWHero'
```

然后运行：

```bash
pod install
```

## 系统要求

- iOS 12.0+
- Swift 5.0+

## 主要功能

### 1. 基础转场动画

使用 LWHero 创建优雅的视图控制器转场：

```swift
import LWHero

// 在源视图控制器中
class SourceViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 为视图设置 hero ID
        imageView.hero.id = "profileImage"
    }

    @IBAction func showDetail(_ sender: Any) {
        let detailVC = DetailViewController()
        detailVC.hero.isEnabled = true
        present(detailVC, animated: true)
    }
}

// 在目标视图控制器中
class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 使用相同的 hero ID
        imageView.hero.id = "profileImage"
    }
}
```

### 2. 自定义动画修饰符

LWHero 提供了丰富的动画修饰符来自定义转场效果：

```swift
import LWHero

// 淡入淡出
view.hero.modifiers = [.fade]

// 缩放
view.hero.modifiers = [.scale(0.5)]

// 旋转
view.hero.modifiers = [.rotate(CGFloat.pi)]

// 位移
view.hero.modifiers = [.translate(x: 100, y: 50)]

// 组合多个修饰符
view.hero.modifiers = [.fade, .scale(0.5), .rotate(CGFloat.pi / 2)]
```

### 3. 动画时间曲线

自定义动画的时间曲线：

```swift
import LWHero

// 使用系统预定义曲线
view.hero.modifiers = [.timingFunction(.easeInOut)]

// 使用自定义贝塞尔曲线
view.hero.modifiers = [
    .timingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1))
]

// 设置动画延迟
view.hero.modifiers = [.delay(0.5)]

// 设置动画时长
view.hero.modifiers = [.duration(2.0)]
```

### 4. 层级动画

创建层叠式动画效果：

```swift
import LWHero

// 按顺序为子视图添加延迟
let views = [view1, view2, view3, view4]
for (index, view) in views.enumerated() {
    view.hero.modifiers = [
        .fade,
        .translate(y: 50),
        .delay(Double(index) * 0.1)
    ]
}

// 使用 cascade 修饰符
containerView.hero.modifiers = [.cascade(delta: 0.1)]
```

### 5. 导航栏转场

处理导航栏的转场动画：

```swift
import LWHero

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 启用 Hero 动画
        hero.isEnabled = true

        // 为导航栏元素设置 hero ID
        navigationItem.titleView?.hero.id = "navigationTitle"
    }
}
```

### 6. UIKit 扩展

LWHero 为 UIKit 提供了便捷的扩展：

```swift
import LWHero

// UIViewController 扩展
viewController.hero.isEnabled = true
viewController.hero.modalAnimationType = .selectBy(
    presenting: .fade,
    dismissing: .slide(.down)
)

// UIView 扩展
view.hero.id = "uniqueID"
view.hero.modifiers = [.fade, .scale(1.2)]

// CALayer 扩展
layer.hero.modifiers = [.opacity(0.5)]
```

## 高级功能

### 自定义转场

创建完全自定义的转场效果：

```swift
import LWHero

class CustomHeroAnimator: HeroDefaultAnimator {
    override func animate(
        fromViews: [UIView],
        toViews: [UIView]
    ) -> TimeInterval {
        // 自定义动画逻辑
        return super.animate(fromViews: fromViews, toViews: toViews)
    }
}

// 使用自定义动画器
Hero.shared.defaultAnimator = CustomHeroAnimator()
```

### 插件系统

使用插件扩展 Hero 功能：

```swift
import LWHero

class CustomHeroPlugin: HeroPlugin {
    func process(
        context: HeroContext,
        fromViews: [UIView],
        toViews: [UIView]
    ) {
        // 自定义处理逻辑
    }
}

// 添加插件
Hero.shared.plugins.append(CustomHeroPlugin())
```

### 交互式转场

创建可交互的手势驱动转场：

```swift
import LWHero

class ViewController: UIViewController {
    var panGR: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGR)
    }

    @objc func handlePan(_ gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: nil)
        let progress = translation.y / view.bounds.height

        switch gr.state {
        case .began:
            Hero.shared.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
        default:
            if progress > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}
```

## 预定义修饰符

LWHero 提供了多种预定义修饰符：

- `.fade` - 淡入淡出
- `.scale(CGFloat)` - 缩放
- `.rotate(CGFloat)` - 旋转
- `.translate(x: CGFloat, y: CGFloat)` - 位移
- `.source(heroID: String)` - 源视图
- `.timingFunction(CAMediaTimingFunction)` - 时间曲线
- `.duration(TimeInterval)` - 动画时长
- `.delay(TimeInterval)` - 延迟
- `.spring(stiffness: CGFloat, damping: CGFloat)` - 弹簧动画
- `.cascade(delta: TimeInterval)` - 层叠动画
- `.ignoreSubviewModifiers` - 忽略子视图修饰符

## 注意事项

1. **性能优化**：避免在大量视图上同时应用复杂的 hero 修饰符
2. **ID 唯一性**：确保相同转场中的 hero ID 是唯一的
3. **内存管理**：及时清理不再使用的 hero 修饰符
4. **导航栏**：处理导航栏转场时需要特别注意
5. **SwiftUI 支持**：部分功能在 SwiftUI 中的使用方式略有不同

## 迁移指南

从 LWHeroOC (Objective-C) 迁移到 LWHero (Swift)：

| Objective-C | Swift |
|-------------|-------|
| `view.heroID = @"id"` | `view.hero.id = "id"` |
| `view.heroModifiers = @[@"fade"]` | `view.hero.modifiers = [.fade]` |
| `[Hero sharedInstance]` | `Hero.shared` |

## 示例项目

查看 Example 目录中的示例项目，了解更多使用场景和最佳实践。

## Objective-C 版本

如果你的项目使用 Objective-C，请使用 LWHeroOC：

```ruby
pod 'LWHeroOC'
```

详细使用说明请参考 [README.md](README.md)

## 许可证

LWHero 使用 MIT 许可证。详见 LICENSE 文件。
