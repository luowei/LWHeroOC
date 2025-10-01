# LWHeroOC

[![CI Status](https://img.shields.io/travis/luowei/LWHeroOC.svg?style=flat)](https://travis-ci.org/luowei/LWHeroOC)
[![Version](https://img.shields.io/cocoapods/v/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)
[![License](https://img.shields.io/cocoapods/l/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)
[![Platform](https://img.shields.io/cocoapods/p/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)

## 简介

LWHeroOC 是一个优雅的 iOS 视图控制器转场动画框架，用于创建类似于 Keynote 的神奇移动（Magic Move）效果动画。此框架基于 Hero-ObjectiveC 修改完善而来，提供了丰富的动画效果和灵活的配置选项，让您的 iOS 应用拥有流畅自然的页面转场体验。

通过简单的 API 调用和声明式的修饰符（Modifiers）配置，您可以轻松实现各种复杂的转场动画效果，包括淡入淡出、缩放、旋转、位移等，以及它们的组合效果。

## 核心特性

### 丰富的动画效果
- **基础动画**: 淡入淡出（fade）、位置（position）、大小（size）
- **3D 变换**: 透视（perspective）、旋转（rotate）、缩放（scale）、平移（translate）
- **时序控制**: 自定义动画时长（duration）、延迟（delay）、时间曲线（timing function）
- **弹簧动画**: 支持 iOS 9+ 的弹簧动画，可自定义刚度（stiffness）和阻尼（damping）

### 高级特性
- **视图匹配**: 自动匹配具有相同 heroID 的视图，实现无缝转场
- **级联动画**: 为子视图应用递增的延迟效果，创造波浪式动画
- **弧线运动**: 结合位置修饰符，实现自然的弧线移动轨迹
- **层级控制**: 通过 zPosition 控制动画期间的视图绘制顺序
- **交互式转场**: 支持手势驱动的可交互转场动画
- **插件系统**: 可扩展的插件架构，支持自定义动画器和预处理器

### 易于使用
- **声明式 API**: 通过 heroID 和 heroModifiers 属性轻松配置
- **Interface Builder 支持**: 支持在 Storyboard 中通过 IBInspectable 配置
- **全局坐标系**: 支持全局和局部坐标空间转换
- **代理回调**: 提供完整的动画生命周期回调

## 系统要求

- iOS 8.0 或更高版本
- Xcode 8.0 或更高版本
- Objective-C

## 安装

### CocoaPods

LWHeroOC 可通过 [CocoaPods](https://cocoapods.org) 安装。在您的 Podfile 中添加以下内容：

```ruby
pod 'LWHeroOC'
```

然后运行：

```bash
pod install
```

### Carthage

您也可以使用 [Carthage](https://github.com/Carthage/Carthage) 安装。在您的 Cartfile 中添加：

```ruby
github "luowei/LWHeroOC"
```

然后运行：

```bash
carthage update
```

## 快速开始

### 1. 启用 Hero 转场

在您的视图控制器中启用 Hero 转场：

```objective-c
#import <LWHeroOC/UIKit+Hero.h>

// 在源视图控制器中
self.isHeroEnabled = YES;

// 在目标视图控制器中
nextViewController.isHeroEnabled = YES;
```

### 2. 为视图设置 heroID

为需要转场的视图设置唯一的 heroID，具有相同 heroID 的视图将自动匹配并产生转场动画：

```objective-c
// 在源视图控制器中
self.imageView.heroID = @"profileImage";

// 在目标视图控制器中
self.imageView.heroID = @"profileImage";
```

### 3. 执行转场

使用标准的 UIKit 导航方法：

```objective-c
// Push
[self.navigationController pushViewController:nextViewController animated:YES];

// Present
[self presentViewController:nextViewController animated:YES completion:nil];

// Dismiss
[self.navigationController popViewControllerAnimated:YES];
```

## 使用示例

### 基础淡入淡出效果

```objective-c
#import <LWHeroOC/HeroModifier.h>

view.heroModifiers = @[[HeroModifier fade]];
```

### 位置和大小动画

```objective-c
// 设置目标位置
view.heroModifiers = @[[HeroModifier position:[NSValue valueWithCGPoint:CGPointMake(100, 100)]]];

// 设置目标大小
view.heroModifiers = @[[HeroModifier size:[NSValue valueWithCGSize:CGSizeMake(200, 200)]]];
```

### 3D 变换动画

```objective-c
// 缩放动画
view.heroModifiers = @[[HeroModifier scaleXY:1.5]];

// 旋转动画
view.heroModifiers = @[[HeroModifier rotateZ:M_PI]];

// 平移动画
view.heroModifiers = @[[HeroModifier translateX:100 Y:50 Z:0]];

// 组合效果
view.heroModifiers = @[
    [HeroModifier scaleXY:0.5],
    [HeroModifier rotateZ:M_PI_4],
    [HeroModifier translateX:100 Y:100 Z:0]
];
```

### 时序控制

```objective-c
// 设置动画时长为 0.5 秒
view.heroModifiers = @[[HeroModifier duration:@(0.5)]];

// 延迟 0.2 秒后开始动画
view.heroModifiers = @[[HeroModifier delay:@(0.2)]];

// 使用弹簧动画 (iOS 9+)
view.heroModifiers = @[[HeroModifier spring:300 damping:20]];

// 组合时序效果
view.heroModifiers = @[
    [HeroModifier duration:@(0.8)],
    [HeroModifier delay:@(0.1)],
    [HeroModifier fade]
];
```

### 级联动画

为子视图创建波浪式动画效果：

```objective-c
// 使用默认参数的级联效果
containerView.heroModifiers = @[[HeroModifier cascade]];

// 自定义级联参数
containerView.heroModifiers = @[
    [HeroModifier cascadeWithDelta:0.02
                         direction:CascadeDirectionTopToBottom
                  delayMatchedViews:NO]
];
```

### 弧线运动

```objective-c
// 创建自然的弧线移动轨迹
view.heroModifiers = @[
    [HeroModifier position:[NSValue valueWithCGPoint:CGPointMake(200, 300)]],
    [HeroModifier arc:@(1)]  // 1 表示向下的弧线，-1 表示向上的弧线
];
```

### 源视图匹配

从另一个视图的状态转场：

```objective-c
view.heroModifiers = @[[HeroModifier source:@"sourceViewID"]];
```

### TableView 示例

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    // 为 cell 添加动画效果
    cell.heroModifiers = @[
        [HeroModifier fade],
        [HeroModifier translateX:-100 Y:0 Z:0]
    ];

    // 为 imageView 设置 heroID 和动画效果
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.row];
    cell.imageView.heroModifiers = @[
        [HeroModifier arc:@(1)],
        [HeroModifier zPosition:@(10)]
    ];

    return cell;
}
```

### 使用 Interface Builder

您可以在 Storyboard 中直接配置 Hero 动画：

1. 选择视图，在 Identity Inspector 中找到 User Defined Runtime Attributes
2. 添加以下属性：
   - `heroID` (String): 设置视图的唯一标识符
   - `heroModifierString` (String): 使用字符串配置修饰符，例如 `"fade translate(100,0)"`
   - `isHeroEnabled` (Boolean): 在视图控制器上启用 Hero

### HeroViewControllerDelegate 回调

实现 Hero 动画生命周期回调：

```objective-c
@interface MyViewController () <HeroViewControllerDelegate>
@end

@implementation MyViewController

- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    // 即将开始转场到目标视图控制器
    self.tableView.heroModifiers = @[[HeroModifier cascade]];
}

- (void)heroDidEndAnimatingTo:(UIViewController *)viewController {
    // 转场到目标视图控制器完成
}

- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController {
    // 即将开始从目标视图控制器返回
}

- (void)heroDidEndAnimatingFrom:(UIViewController *)viewController {
    // 从目标视图控制器返回完成
}

- (void)heroWillStartTransition {
    // 转场即将开始
}

- (void)heroDidEndTransition {
    // 转场已经结束
}

@end
```

### 交互式转场

Hero 支持手势驱动的可交互转场：

```objective-c
#import <LWHeroOC/Hero.h>

// 开始交互式转场
[[Hero shared] setInteractive:YES];

// 更新转场进度 (0.0 到 1.0)
[[Hero shared] updateProgress:progress];

// 完成转场
[[Hero shared] endAnimated:YES];

// 取消转场
[[Hero shared] cancelAnimated:YES];

// 在交互过程中动态应用修饰符
[[Hero shared] applyModifiers:@[[HeroModifier position:[NSValue valueWithCGPoint:point]]]
                       toView:view];
```

### 监听转场进度

```objective-c
@interface MyViewController () <HeroProgressUpdateObserver>
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Hero shared] observeForProgressUpdateWithObserver:self];
}

- (void)heroDidUpdateProgress:(double)progress {
    // 转场进度已更新 (0.0 到 1.0)
    NSLog(@"Transition progress: %.2f", progress);
}

@end
```

### 视图替换

使用 Hero 动画平滑替换视图控制器：

```objective-c
NextViewController *nextVC = [[NextViewController alloc] init];
[self heroReplaceViewControllerWithNext:nextVC];
```

### 插件系统

启用或禁用特定插件：

```objective-c
// 启用插件
[Hero enablePlugin:[MyCustomPlugin class]];

// 禁用插件
[Hero disablePlugin:[MyCustomPlugin class]];

// 检查插件是否启用
BOOL enabled = [Hero isEnabledPlugin:[MyCustomPlugin class]];
```

## API 文档

### UIView (Hero)

```objective-c
@interface UIView (Hero)

// 视图的唯一标识符，用于匹配转场视图
@property (nonatomic, copy) IBInspectable NSString *heroID;

// 应用于视图的修饰符数组
@property (nonatomic, strong) IBInspectable NSArray<HeroModifier *> *heroModifiers;

// 使用字符串配置修饰符（支持 IB）
@property (nonatomic, copy) IBInspectable NSString *heroModifierString;

// 创建视图的慢速快照
- (UIView *)slowSnapshotView;

@end
```

### UIViewController (Hero)

```objective-c
@interface UIViewController (Delegate)

// 是否启用 Hero 转场
@property (nonatomic, assign) IBInspectable BOOL isHeroEnabled;

// 使用 Hero 动画替换当前视图控制器
- (void)heroReplaceViewControllerWithNext:(UIViewController *)next;

// 使用 Hero 动画 dismiss
- (IBAction)ht_dismiss:(id)sender;

@end
```

### HeroModifier

#### 基础修饰符

```objective-c
// 淡入淡出效果
+ (HeroModifier *)fade;

// 设置位置
+ (HeroModifier *)position:(NSValue *)position;  // CGPoint

// 设置大小
+ (HeroModifier *)size:(NSValue *)size;  // CGSize
```

#### 变换修饰符

```objective-c
// 设置 CATransform3D
+ (HeroModifier *)transform:(NSValue *)t;

// 设置透视距离
+ (HeroModifier *)perspective:(CGFloat)perspective;

// 3D 缩放
+ (HeroModifier *)scaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 2D 缩放
+ (HeroModifier *)scaleXY:(CGFloat)xy;

// 3D 平移
+ (HeroModifier *)translateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 3D 旋转
+ (HeroModifier *)rotateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 2D 旋转
+ (HeroModifier *)rotateZ:(CGFloat)z;
```

#### 时序修饰符

```objective-c
// 设置动画时长（秒）
+ (HeroModifier *)duration:(NSNumber *)duration;

// 设置动画延迟（秒）
+ (HeroModifier *)delay:(NSNumber *)delay;

// 设置时间函数
+ (HeroModifier *)timingFunction:(CAMediaTimingFunction *)timingFunction;

// 弹簧动画 (iOS 9+)
+ (HeroModifier *)spring:(CGFloat)stiffness damping:(CGFloat)damping;
```

#### 其他修饰符

```objective-c
// 设置 z 轴位置（控制绘制顺序）
+ (HeroModifier *)zPosition:(NSNumber *)zPosition;

// 仅在匹配时设置 z 轴位置
+ (HeroModifier *)zPositionIfMatched:(NSNumber *)zPositionIfMatched;

// 忽略子视图修饰符
+ (HeroModifier *)ignoreSubviewModifiersWithRecursive:(NSNumber *)recursive;

// 从指定源视图转场
+ (HeroModifier *)source:(NSString *)heroID;

// 弧线运动（intensity: 1 为向下，-1 为向上）
+ (HeroModifier *)arc:(NSNumber *)intensity;

// 级联效果
+ (HeroModifier *)cascade;
+ (HeroModifier *)cascadeWithDelta:(NSTimeInterval)delta
                         direction:(CascadeDirection)direction
                  delayMatchedViews:(BOOL)delayMatchedViews;

// 使用全局坐标系
+ (HeroModifier *)useGlobalCoordinateSpace;
```

### Hero 单例

```objective-c
@interface Hero : NSObject

// 获取共享实例
+ (instancetype)shared;

// 目标视图控制器
@property (nonatomic, weak, readonly) UIViewController *toViewController;

// 源视图控制器
@property (nonatomic, weak, readonly) UIViewController *fromViewController;

// 上下文对象
@property (nonatomic, strong, readonly) HeroContext *context;

// 是否正在呈现
@property (nonatomic, assign, readonly) BOOL presenting;

// 是否为交互式转场
@property (nonatomic, assign) BOOL interactive;

// 当前转场进度（0.0 - 1.0）
@property (nonatomic, assign, readonly) CGFloat progress;

// 是否正在转场
@property (nonatomic, assign) BOOL transitioning;

// 动画容器视图
@property (nonatomic, strong, readonly) UIView *container;

@end
```

#### 交互式转场方法

```objective-c
// 更新转场进度
- (void)updateProgress:(CGFloat)progress;

// 完成转场
- (void)endAnimated:(BOOL)animate;

// 取消转场
- (void)cancelAnimated:(BOOL)animate;

// 在交互过程中应用修饰符
- (void)applyModifiers:(NSArray *)modifiers toView:(UIView *)view;
```

#### 观察者方法

```objective-c
// 观察转场进度更新
- (void)observeForProgressUpdateWithObserver:(id<HeroProgressUpdateObserver>)observer;
```

#### 插件管理

```objective-c
// 检查插件是否启用
+ (BOOL)isEnabledPlugin:(Class)plugin;

// 启用插件
+ (void)enablePlugin:(Class)plugin;

// 禁用插件
+ (void)disablePlugin:(Class)plugin;
```

### HeroViewControllerDelegate

```objective-c
@protocol HeroViewControllerDelegate <NSObject>

@optional
// 即将开始转场到目标视图控制器
- (void)heroWillStartAnimatingTo:(UIViewController *)viewController;

// 转场到目标视图控制器完成
- (void)heroDidEndAnimatingTo:(UIViewController *)viewController;

// 即将开始从目标视图控制器返回
- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController;

// 从目标视图控制器返回完成
- (void)heroDidEndAnimatingFrom:(UIViewController *)viewController;

// 转场即将开始
- (void)heroWillStartTransition;

// 转场已经结束
- (void)heroDidEndTransition;

@end
```

### HeroProgressUpdateObserver

```objective-c
@protocol HeroProgressUpdateObserver <NSObject>

// 转场进度更新回调
- (void)heroDidUpdateProgress:(double)progress;

@end
```

### CascadeDirection 枚举

```objective-c
typedef NS_ENUM(NSInteger, CascadeDirection) {
    CascadeDirectionTopToBottom,     // 从上到下
    CascadeDirectionBottomToTop,     // 从下到上
    CascadeDirectionLeftToRight,     // 从左到右
    CascadeDirectionRightToLeft,     // 从右到左
    CascadeDirectionRadial,          // 径向（从中心向外）
    CascadeDirectionInverseRadial    // 反径向（从外向中心）
};
```

## 高级用法

### 自定义动画器

您可以通过实现 `HeroAnimator` 协议来创建自定义动画器：

```objective-c
@protocol HeroAnimator <NSObject>

// 判断是否可以为指定视图执行动画
- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear;

// 执行动画并返回动画时长
- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

// 清理动画资源
- (void)clean;

// 定位到指定时间点
- (void)seekToTime:(NSTimeInterval)timePassed;

// 从指定时间恢复动画
- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse;

// 应用状态到视图
- (void)applyState:(HeroTargetState *)state toView:(UIView *)view;

@end
```

### 自定义预处理器

通过实现 `HeroPreprocessor` 协议来创建自定义预处理器：

```objective-c
@protocol HeroPreprocessor <NSObject>

// 预处理源视图和目标视图
- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
```

## 示例项目

要运行示例项目，请按照以下步骤操作：

1. 克隆仓库：
```bash
git clone https://github.com/luowei/LWHeroOC.git
```

2. 进入 Example 目录：
```bash
cd LWHeroOC/Example
```

3. 安装依赖：
```bash
pod install
```

4. 打开工作空间：
```bash
open LWHeroOC.xcworkspace
```

示例项目包含多个演示场景：

- **ListToGrid**: TableView 到 CollectionView 的转场效果
- **ImageGallery**: 图片画廊浏览转场动画
- **CityGuide**: 城市指南卡片转场效果
- **MusicPlayer**: 音乐播放器界面转场

## 最佳实践

### 1. 性能优化

- 对于复杂的视图层级，考虑使用 `ignoreSubviewModifiers` 来减少动画计算
- 在 TableView 或 CollectionView 中使用 Hero 时，注意控制可见 cell 的数量
- 避免在动画过程中进行大量计算或 IO 操作

### 2. 动画设计

- 保持动画时长在 0.3 - 0.6 秒之间，以获得最佳用户体验
- 使用弹簧动画（spring）可以让动画更自然
- 适当使用延迟和级联效果可以增加动画的层次感
- 避免过度使用动画，保持简洁明了

### 3. 视图匹配

- 确保匹配的视图具有相同的 heroID
- 对于需要精确匹配的视图，使用全局坐标系（`useGlobalCoordinateSpace`）
- 使用 `source` 修饰符可以实现更灵活的视图匹配

### 4. 调试技巧

- 使用较长的动画时长（如 2.0 秒）来观察动画细节
- 实现 `HeroProgressUpdateObserver` 来监控转场进度
- 使用 `heroWillStartAnimatingTo/From` 回调来调试视图状态

## 常见问题

### Q: 为什么我的视图没有动画效果？

A: 请检查以下几点：
1. 确保视图控制器的 `isHeroEnabled` 属性设置为 `YES`
2. 确认视图设置了正确的 `heroID` 或 `heroModifiers`
3. 检查视图是否在转场开始时可见
4. 确保没有其他转场动画覆盖了 Hero 动画

### Q: 如何禁用某个特定转场的 Hero 动画？

A: 将视图控制器的 `isHeroEnabled` 设置为 `NO` 即可：

```objective-c
nextViewController.isHeroEnabled = NO;
```

### Q: 可以在导航栏转场中使用 Hero 吗？

A: 可以。Hero 完全支持 UINavigationController 的 push/pop 转场。只需确保相关视图控制器启用了 Hero。

### Q: 如何实现类似于 iOS Photos 应用的图片查看转场？

A: 使用视图匹配功能，为源视图和目标视图设置相同的 heroID，Hero 会自动处理位置、大小的转场。参考示例项目中的 ImageGallery 场景。

### Q: 交互式转场如何取消？

A: 调用 `[[Hero shared] cancelAnimated:YES]` 即可取消当前的交互式转场并返回到初始状态。

## 技术支持

如果您在使用 LWHeroOC 时遇到问题或有任何建议，欢迎：

- 提交 [Issue](https://github.com/luowei/LWHeroOC/issues)
- 发送 Pull Request
- 联系作者：luowei@wodedata.com

## 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 作者

**luowei** - [GitHub](https://github.com/luowei)

邮箱：luowei@wodedata.com

## 致谢

- 本项目基于 [Hero-ObjectiveC](https://github.com/luca-li/Hero-ObjectiveC) 修改完善
- 灵感来源于 Apple Keynote 的神奇移动效果
- 感谢所有贡献者的支持

## 许可证

LWHeroOC 采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

```
Copyright (c) 2020 luowei <luowei@wodedata.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

## 更新日志

### 1.0.0
- 基于 Hero-ObjectiveC 的稳定版本
- 支持 iOS 8.0+
- 完整的动画修饰符系统
- 交互式转场支持
- 插件系统
- CocoaPods 和 Carthage 支持
