# LWHeroOC

[![CI Status](https://img.shields.io/travis/luowei/LWHeroOC.svg?style=flat)](https://travis-ci.org/luowei/LWHeroOC)
[![Version](https://img.shields.io/cocoapods/v/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)
[![License](https://img.shields.io/cocoapods/l/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)
[![Platform](https://img.shields.io/cocoapods/p/LWHeroOC.svg?style=flat)](https://cocoapods.org/pods/LWHeroOC)

[中文文档 (Chinese Documentation)](README_ZH.md)

## Introduction

LWHeroOC is an elegant iOS view controller transition animation framework that brings beautiful and smooth transitions to your iOS applications, similar to Keynote's Magic Move effect. Built upon Hero-ObjectiveC with significant improvements, LWHeroOC provides rich animation effects and flexible configuration options through a simple, declarative API.

With just a few lines of code and declarative modifiers, you can create complex transition animations including fade, scale, rotate, translate, and their combinations, making your app's user experience more fluid and natural.

## Core Features

### Rich Animation Effects
- **Basic Animations**: Fade, position, size
- **3D Transformations**: Perspective, rotate, scale, translate
- **Timing Control**: Custom duration, delay, timing functions
- **Spring Animations**: iOS 9+ spring animations with customizable stiffness and damping
- **Arc Motion**: Natural curved motion paths combining position modifiers

### Advanced Capabilities
- **View Matching**: Automatic matching of views with the same heroID for seamless transitions
- **Cascade Animations**: Apply incremental delays to subviews creating wave-like effects
- **Layer Control**: Control view drawing order during animations with zPosition
- **Interactive Transitions**: Gesture-driven interactive transitions with progress tracking
- **Plugin System**: Extensible plugin architecture supporting custom animators and preprocessors

### Easy to Use
- **Declarative API**: Simple configuration through heroID and heroModifiers properties
- **Interface Builder Support**: Configure animations in Storyboard via IBInspectable properties
- **Global Coordinate System**: Support for global and local coordinate space transformations
- **Delegate Callbacks**: Complete animation lifecycle callbacks

## Requirements

- iOS 8.0 or higher
- Xcode 8.0 or higher
- Objective-C

## Installation

### CocoaPods

LWHeroOC is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LWHeroOC'
```

Then run:

```bash
pod install
```

### Carthage

You can also install LWHeroOC using [Carthage](https://github.com/Carthage/Carthage). Add this to your Cartfile:

```ruby
github "luowei/LWHeroOC"
```

Then run:

```bash
carthage update
```

## Quick Start

### 1. Enable Hero Transition

Enable Hero transition in your view controllers:

```objective-c
#import <LWHeroOC/UIKit+Hero.h>

// In source view controller
self.isHeroEnabled = YES;

// In destination view controller
nextViewController.isHeroEnabled = YES;
```

### 2. Set heroID for Views

Set a unique heroID for views that should transition together. Views with matching heroIDs will automatically create smooth transitions:

```objective-c
// In source view controller
self.imageView.heroID = @"profileImage";

// In destination view controller
self.imageView.heroID = @"profileImage";
```

### 3. Perform Transition

Use standard UIKit navigation methods:

```objective-c
// Push
[self.navigationController pushViewController:nextViewController animated:YES];

// Present
[self presentViewController:nextViewController animated:YES completion:nil];

// Dismiss
[self.navigationController popViewControllerAnimated:YES];
```

## Usage Examples

### Basic Fade Effect

```objective-c
#import <LWHeroOC/HeroModifier.h>

view.heroModifiers = @[[HeroModifier fade]];
```

### Position and Size Animations

```objective-c
// Set target position
view.heroModifiers = @[[HeroModifier position:[NSValue valueWithCGPoint:CGPointMake(100, 100)]]];

// Set target size
view.heroModifiers = @[[HeroModifier size:[NSValue valueWithCGSize:CGSizeMake(200, 200)]]];
```

### 3D Transform Animations

```objective-c
// Scale animation
view.heroModifiers = @[[HeroModifier scaleXY:1.5]];

// Rotation animation
view.heroModifiers = @[[HeroModifier rotateZ:M_PI]];

// Translation animation
view.heroModifiers = @[[HeroModifier translateX:100 Y:50 Z:0]];

// Combined effects
view.heroModifiers = @[
    [HeroModifier scaleXY:0.5],
    [HeroModifier rotateZ:M_PI_4],
    [HeroModifier translateX:100 Y:100 Z:0]
];
```

### Timing Control

```objective-c
// Set animation duration to 0.5 seconds
view.heroModifiers = @[[HeroModifier duration:@(0.5)]];

// Delay animation start by 0.2 seconds
view.heroModifiers = @[[HeroModifier delay:@(0.2)]];

// Use spring animation (iOS 9+)
view.heroModifiers = @[[HeroModifier spring:300 damping:20]];

// Combined timing effects
view.heroModifiers = @[
    [HeroModifier duration:@(0.8)],
    [HeroModifier delay:@(0.1)],
    [HeroModifier fade]
];
```

### Cascade Animations

Create wave-like animation effects for subviews:

```objective-c
// Use default cascade parameters
containerView.heroModifiers = @[[HeroModifier cascade]];

// Customize cascade parameters
containerView.heroModifiers = @[
    [HeroModifier cascadeWithDelta:0.02
                         direction:CascadeDirectionTopToBottom
                  delayMatchedViews:NO]
];
```

### Arc Motion

```objective-c
// Create natural arc motion paths
view.heroModifiers = @[
    [HeroModifier position:[NSValue valueWithCGPoint:CGPointMake(200, 300)]],
    [HeroModifier arc:@(1)]  // 1 for downward arc, -1 for upward arc
];
```

### Source View Matching

Transition from another view's state:

```objective-c
view.heroModifiers = @[[HeroModifier source:@"sourceViewID"]];
```

## Comprehensive Transition Examples

### Example 1: Image Gallery Transition

Create smooth transitions between a collection view and detail view:

```objective-c
// In collection view controller
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                 forIndexPath:indexPath];

    // Set heroID for matched transition
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];
    cell.imageView.heroModifiers = @[[HeroModifier zPosition:@(100)]];

    // Add fade and scale effects to the cell
    cell.heroModifiers = @[
        [HeroModifier fade],
        [HeroModifier scaleXY:0.8],
        [HeroModifier zPosition:@(50)]
    ];

    return cell;
}

// In detail view controller
- (void)viewDidLoad {
    [super viewDidLoad];

    // Match the heroID
    self.imageView.heroID = [NSString stringWithFormat:@"image_%zi", self.selectedIndex];

    // Add background fade in
    self.view.heroModifiers = @[[HeroModifier fade]];
}
```

### Example 2: List to Grid Transition

Smooth transition between list and grid layouts:

```objective-c
// In list view controller
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];

    // Set heroID for the cell
    cell.heroModifiers = @[
        [HeroModifier fade],
        [HeroModifier translateX:-100 Y:0 Z:0]
    ];

    // Match the image view
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.row];
    cell.imageView.heroModifiers = @[
        [HeroModifier arc:@(1)],
        [HeroModifier zPosition:@(10)]
    ];

    return cell;
}

// In grid view controller
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridCell"
                                                                forIndexPath:indexPath];

    // Match heroID from list
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];

    return cell;
}
```

### Example 3: Modal Presentation with Background Blur

```objective-c
// In presenting view controller
- (void)presentDetailViewController {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.isHeroEnabled = YES;
    detailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    [self presentViewController:detailVC animated:YES completion:nil];
}

// In detail view controller
- (void)viewDidLoad {
    [super viewDidLoad];

    // Fade in the background
    self.backgroundView.heroModifiers = @[[HeroModifier fade]];

    // Slide up the content with spring
    self.contentView.heroModifiers = @[
        [HeroModifier translateX:0 Y:500 Z:0],
        [HeroModifier spring:250 damping:25]
    ];

    // Scale and fade the dismiss button
    self.dismissButton.heroModifiers = @[
        [HeroModifier fade],
        [HeroModifier scaleXY:0.5],
        [HeroModifier delay:@(0.2)]
    ];
}
```

### Example 4: Radial Cascade from Selected Cell

```objective-c
// In collection view controller implementing HeroViewControllerDelegate
- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    ImageCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];

    CascadePreprocessor *preprocessor = [[CascadePreprocessor alloc]
        initWithDirectionType:CascadeDirectionRadial
                       center:[NSValue valueWithCGPoint:cell.center]];

    self.collectionView.heroModifiers = @[
        [HeroModifier cascadeWithDelta:0.015
                             direction:preprocessor.direction
                      delayMatchedViews:NO]
    ];
}
```

### Example 5: Navigation Bar Transition

```objective-c
// In source view controller
- (void)viewDidLoad {
    [super viewDidLoad];

    // Match navigation bar elements
    self.navigationItem.titleView.heroID = @"navigationTitle";
    self.navigationItem.rightBarButtonItem.customView.heroID = @"rightButton";
}

// In destination view controller
- (void)viewDidLoad {
    [super viewDidLoad];

    // Match the same heroIDs
    self.navigationItem.titleView.heroID = @"navigationTitle";
    self.navigationItem.rightBarButtonItem.customView.heroID = @"rightButton";
}
```

### Example 6: TableView with Cascade Effect

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];

    // Add cascade effect with fade and slide
    cell.heroModifiers = @[
        [HeroModifier fade],
        [HeroModifier translateX:-100 Y:0 Z:0],
        [HeroModifier delay:@(indexPath.row * 0.05)]
    ];

    return cell;
}
```

## Interface Builder Integration

Configure Hero animations directly in Storyboard:

1. Select a view in Interface Builder
2. Open the Identity Inspector
3. Add User Defined Runtime Attributes:
   - `heroID` (String): Set unique identifier for view matching
   - `heroModifierString` (String): Configure modifiers using string format, e.g., `"fade translate(100,0) scale(0.5)"`
   - `isHeroEnabled` (Boolean): Enable Hero on view controller

## HeroViewControllerDelegate Callbacks

Implement animation lifecycle callbacks:

```objective-c
@interface MyViewController () <HeroViewControllerDelegate>
@end

@implementation MyViewController

- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    // About to start transition to destination view controller
    self.tableView.heroModifiers = @[[HeroModifier cascade]];
}

- (void)heroDidEndAnimatingTo:(UIViewController *)viewController {
    // Finished transition to destination view controller
}

- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController {
    // About to start returning from destination view controller
}

- (void)heroDidEndAnimatingFrom:(UIViewController *)viewController {
    // Finished returning from destination view controller
}

- (void)heroWillStartTransition {
    // Transition is about to start
}

- (void)heroDidEndTransition {
    // Transition has ended
}

@end
```

## Interactive Transitions

Hero supports gesture-driven interactive transitions:

```objective-c
#import <LWHeroOC/Hero.h>

// Start interactive transition
[[Hero shared] setInteractive:YES];

// Update transition progress (0.0 to 1.0)
[[Hero shared] updateProgress:progress];

// Complete transition
[[Hero shared] endAnimated:YES];

// Cancel transition
[[Hero shared] cancelAnimated:YES];

// Apply modifiers during interaction
[[Hero shared] applyModifiers:@[[HeroModifier position:[NSValue valueWithCGPoint:point]]]
                       toView:view];
```

### Progress Monitoring

```objective-c
@interface MyViewController () <HeroProgressUpdateObserver>
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Hero shared] observeForProgressUpdateWithObserver:self];
}

- (void)heroDidUpdateProgress:(double)progress {
    // Transition progress updated (0.0 to 1.0)
    NSLog(@"Transition progress: %.2f", progress);
}

@end
```

### View Controller Replacement

Smoothly replace view controller using Hero animation:

```objective-c
NextViewController *nextVC = [[NextViewController alloc] init];
[self heroReplaceViewControllerWithNext:nextVC];
```

## Plugin System

Enable or disable specific plugins:

```objective-c
// Enable plugin
[Hero enablePlugin:[MyCustomPlugin class]];

// Disable plugin
[Hero disablePlugin:[MyCustomPlugin class]];

// Check if plugin is enabled
BOOL enabled = [Hero isEnabledPlugin:[MyCustomPlugin class]];
```

## Complete API Documentation

### UIView (Hero)

```objective-c
@interface UIView (Hero)

// Unique identifier for view matching during transitions
@property (nonatomic, copy) IBInspectable NSString *heroID;

// Array of modifiers applied to the view
@property (nonatomic, strong) IBInspectable NSArray<HeroModifier *> *heroModifiers;

// Configure modifiers using string format (IB supported)
@property (nonatomic, copy) IBInspectable NSString *heroModifierString;

// Create a slow snapshot of the view
- (UIView *)slowSnapshotView;

@end
```

### UIViewController (Hero)

```objective-c
@interface UIViewController (Delegate)

// Enable/disable Hero transition for this view controller
@property (nonatomic, assign) IBInspectable BOOL isHeroEnabled;

// Replace current view controller with Hero animation
- (void)heroReplaceViewControllerWithNext:(UIViewController *)next;

// Dismiss with Hero animation
- (IBAction)ht_dismiss:(id)sender;

@end
```

### HeroModifier

#### Basic Modifiers

```objective-c
// Fade effect during transition
+ (HeroModifier *)fade;

// Set target position (CGPoint wrapped in NSValue)
+ (HeroModifier *)position:(NSValue *)position;

// Set target size (CGSize wrapped in NSValue)
+ (HeroModifier *)size:(NSValue *)size;
```

#### Transform Modifiers

```objective-c
// Set CATransform3D (wrapped in NSValue)
+ (HeroModifier *)transform:(NSValue *)t;

// Set perspective distance for 3D transforms
+ (HeroModifier *)perspective:(CGFloat)perspective;

// 3D scale transformation
+ (HeroModifier *)scaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 2D scale (scales both x and y axes equally)
+ (HeroModifier *)scaleXY:(CGFloat)xy;

// 3D translation
+ (HeroModifier *)translateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 3D rotation (angles in radians)
+ (HeroModifier *)rotateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

// 2D rotation (angle in radians)
+ (HeroModifier *)rotateZ:(CGFloat)z;
```

#### Timing Modifiers

```objective-c
// Set animation duration in seconds
+ (HeroModifier *)duration:(NSNumber *)duration;

// Set animation delay in seconds
+ (HeroModifier *)delay:(NSNumber *)delay;

// Set timing function for animation
+ (HeroModifier *)timingFunction:(CAMediaTimingFunction *)timingFunction;

// Spring animation with custom stiffness and damping (iOS 9+)
+ (HeroModifier *)spring:(CGFloat)stiffness damping:(CGFloat)damping;
```

#### Other Modifiers

```objective-c
// Set z-axis position (controls drawing order during animation)
+ (HeroModifier *)zPosition:(NSNumber *)zPosition;

// Set z-axis position only when view is matched
+ (HeroModifier *)zPositionIfMatched:(NSNumber *)zPositionIfMatched;

// Ignore subview modifiers
+ (HeroModifier *)ignoreSubviewModifiersWithRecursive:(NSNumber *)recursive;

// Transition from specified source view
+ (HeroModifier *)source:(NSString *)heroID;

// Arc motion (intensity: 1 for downward arc, -1 for upward arc)
+ (HeroModifier *)arc:(NSNumber *)intensity;

// Cascade effect with default parameters
+ (HeroModifier *)cascade;

// Cascade effect with custom parameters
+ (HeroModifier *)cascadeWithDelta:(NSTimeInterval)delta
                         direction:(CascadeDirection)direction
                  delayMatchedViews:(BOOL)delayMatchedViews;

// Use global coordinate space for animation
+ (HeroModifier *)useGlobalCoordinateSpace;
```

### Hero Singleton

```objective-c
@interface Hero : NSObject

// Get shared instance
+ (instancetype)shared;

// Destination view controller
@property (nonatomic, weak, readonly) UIViewController *toViewController;

// Source view controller
@property (nonatomic, weak, readonly) UIViewController *fromViewController;

// Context object holding transition information
@property (nonatomic, strong, readonly) HeroContext *context;

// Whether presenting (vs dismissing)
@property (nonatomic, assign, readonly) BOOL presenting;

// Whether transition is interactive
@property (nonatomic, assign) BOOL interactive;

// Current transition progress (0.0 - 1.0)
@property (nonatomic, assign, readonly) CGFloat progress;

// Whether currently transitioning
@property (nonatomic, assign) BOOL transitioning;

// Animation container view
@property (nonatomic, strong, readonly) UIView *container;

@end
```

#### Interactive Transition Methods

```objective-c
// Update transition progress
- (void)updateProgress:(CGFloat)progress;

// Complete transition
- (void)endAnimated:(BOOL)animate;

// Cancel transition
- (void)cancelAnimated:(BOOL)animate;

// Apply modifiers during interaction
- (void)applyModifiers:(NSArray *)modifiers toView:(UIView *)view;
```

#### Observer Methods

```objective-c
// Observe transition progress updates
- (void)observeForProgressUpdateWithObserver:(id<HeroProgressUpdateObserver>)observer;
```

#### Plugin Management

```objective-c
// Check if plugin is enabled
+ (BOOL)isEnabledPlugin:(Class)plugin;

// Enable plugin
+ (void)enablePlugin:(Class)plugin;

// Disable plugin
+ (void)disablePlugin:(Class)plugin;
```

### HeroViewControllerDelegate

```objective-c
@protocol HeroViewControllerDelegate <NSObject>

@optional
// About to start animating to destination view controller
- (void)heroWillStartAnimatingTo:(UIViewController *)viewController;

// Finished animating to destination view controller
- (void)heroDidEndAnimatingTo:(UIViewController *)viewController;

// About to start animating from destination view controller (returning)
- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController;

// Finished animating from destination view controller (returned)
- (void)heroDidEndAnimatingFrom:(UIViewController *)viewController;

// Transition is about to start
- (void)heroWillStartTransition;

// Transition has ended
- (void)heroDidEndTransition;

@end
```

### HeroProgressUpdateObserver

```objective-c
@protocol HeroProgressUpdateObserver <NSObject>

// Called when transition progress is updated
- (void)heroDidUpdateProgress:(double)progress;

@end
```

### CascadeDirection Enumeration

```objective-c
typedef NS_ENUM(NSInteger, CascadeDirection) {
    CascadeDirectionTopToBottom,     // Top to bottom
    CascadeDirectionBottomToTop,     // Bottom to top
    CascadeDirectionLeftToRight,     // Left to right
    CascadeDirectionRightToLeft,     // Right to left
    CascadeDirectionRadial,          // Radial (center outward)
    CascadeDirectionInverseRadial    // Inverse radial (outward to center)
};
```

## Advanced Usage

### Custom Animator

Create custom animators by implementing the `HeroAnimator` protocol:

```objective-c
@protocol HeroAnimator <NSObject>

// Determine if view can be animated
- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear;

// Perform animation and return duration
- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

// Clean up animation resources
- (void)clean;

// Seek to specific time point
- (void)seekToTime:(NSTimeInterval)timePassed;

// Resume animation from specific time
- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse;

// Apply state to view
- (void)applyState:(HeroTargetState *)state toView:(UIView *)view;

@end
```

### Custom Preprocessor

Create custom preprocessors by implementing the `HeroPreprocessor` protocol:

```objective-c
@protocol HeroPreprocessor <NSObject>

// Process source and destination views
- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
```

## Example Project

To run the example project:

1. Clone the repository:
```bash
git clone https://github.com/luowei/LWHeroOC.git
```

2. Navigate to the Example directory:
```bash
cd LWHeroOC/Example
```

3. Install dependencies:
```bash
pod install
```

4. Open the workspace:
```bash
open LWHeroOC.xcworkspace
```

The example project includes multiple demonstration scenarios:

- **ListToGrid**: TableView to CollectionView transition
- **ImageGallery**: Image gallery browsing with smooth transitions
- **CityGuide**: City guide card transitions
- **MusicPlayer**: Music player interface transitions

## Best Practices

### 1. Performance Optimization

- For complex view hierarchies, use `ignoreSubviewModifiers` to reduce animation calculations
- When using Hero in TableView or CollectionView, control the number of visible cells
- Avoid heavy computations or I/O operations during animations

### 2. Animation Design

- Keep animation duration between 0.3 - 0.6 seconds for best user experience
- Use spring animations for more natural motion
- Use delays and cascade effects appropriately to add depth
- Avoid over-animating; keep it simple and clear

### 3. View Matching

- Ensure matching views have the same heroID
- For precise matching, use global coordinate space (`useGlobalCoordinateSpace`)
- Use `source` modifier for more flexible view matching

### 4. Debugging Tips

- Use longer animation durations (e.g., 2.0 seconds) to observe animation details
- Implement `HeroProgressUpdateObserver` to monitor transition progress
- Use `heroWillStartAnimatingTo/From` callbacks to debug view states

## FAQ

### Q: Why aren't my views animating?

A: Check the following:
1. Ensure view controller's `isHeroEnabled` property is set to `YES`
2. Verify views have correct `heroID` or `heroModifiers`
3. Check that views are visible when transition starts
4. Ensure no other transition animations are overriding Hero

### Q: How do I disable Hero for a specific transition?

A: Set the view controller's `isHeroEnabled` to `NO`:

```objective-c
nextViewController.isHeroEnabled = NO;
```

### Q: Can Hero be used with navigation bar transitions?

A: Yes. Hero fully supports UINavigationController push/pop transitions. Just ensure relevant view controllers have Hero enabled.

### Q: How do I create an iOS Photos app-style image viewer transition?

A: Use view matching by setting the same heroID for source and destination views. Hero will automatically handle position and size transitions. See the ImageGallery example in the sample project.

### Q: How do I cancel an interactive transition?

A: Call `[[Hero shared] cancelAnimated:YES]` to cancel the current interactive transition and return to the initial state.

## Support

If you encounter issues or have suggestions:

- Submit an [Issue](https://github.com/luowei/LWHeroOC/issues)
- Send a Pull Request
- Contact: luowei@wodedata.com

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Author

**luowei** - [GitHub](https://github.com/luowei)

Email: luowei@wodedata.com

## Acknowledgments

- Based on [Hero-ObjectiveC](https://github.com/luca-li/Hero-ObjectiveC) with significant improvements
- Inspired by Apple Keynote's Magic Move effect
- Thanks to all contributors

## License

LWHeroOC is available under the MIT license. See the LICENSE file for more info.

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

## Changelog

### 1.0.0
- Stable release based on Hero-ObjectiveC
- Support for iOS 8.0+
- Complete animation modifier system
- Interactive transition support
- Plugin system
- CocoaPods and Carthage support
