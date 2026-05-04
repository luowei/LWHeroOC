# Graph Report - /Users/luowei/projects/libs/LWHeroOC  (2026-05-04)

## Corpus Check
- Large corpus: 222 files · ~816,951 words. Semantic extraction will be expensive (many Claude tokens). Consider running on a subfolder, or use --no-semantic to run AST-only.

## Summary
- 473 nodes · 443 edges · 33 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]

## God Nodes (most connected - your core abstractions)
1. `Hero` - 56 edges
2. `HeroModifier` - 34 edges
3. `HeroContext` - 28 edges
4. `HeroPlugin` - 24 edges
5. `HeroDefaultAnimator` - 18 edges
6. `HeroTargetState` - 17 edges
7. `HeroDefaultAnimatorViewContext` - 15 edges
8. `UIView` - 14 edges
9. `CAMediaTimingFunction` - 13 edges
10. `CascadePreprocessor` - 13 edges

## Surprising Connections (you probably didn't know these)
- `Hero` --inherits--> `NSObject`  [EXTRACTED]
  LWHero_swift/LWHero/Classes/Hero.swift →   _Bridges community 0 → community 3_
- `HeroModifier` --inherits--> `NSObject`  [EXTRACTED]
  LWHero_swift/LWHero/Classes/HeroModifier.swift →   _Bridges community 1 → community 3_
- `HeroDefaultAnimator` --inherits--> `NSObject`  [EXTRACTED]
  LWHero_swift/LWHero/Classes/HeroDefaultAnimator.swift →   _Bridges community 5 → community 3_
- `CascadePreprocessor` --inherits--> `BasePreprocessor`  [EXTRACTED]
  LWHero_swift/LWHero/Classes/CascadePreprocessor.swift →   _Bridges community 6 → community 7_
- `HeroTargetState` --inherits--> `NSObject`  [EXTRACTED]
  LWHero_swift/LWHero/Classes/HeroTargetState.swift →   _Bridges community 8 → community 3_

## Communities (69 total, 7 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.04
Nodes (33): Hero, -animationControllerForDismissedController, -animationControllerForPresentedControllerpresentingControllersourceController, -applyModifierstoView, -cancelAnimated, -closureProcessForHeroDelegateclosure, -completeAfterfinishing, -disablePlugin (+25 more)

### Community 1 - "Community 1"
Cohesion: 0.06
Nodes (13): HeroModifier, -cascadeWithDeltadirectiondelayMatchedViews, -fade, -ignoreSubviewModifiersWithRecursive, -initWithApplyFunction, -modifierFromNameparameters, -rotateXYZ, -rotateZ (+5 more)

### Community 2 - "Community 2"
Cohesion: 0.07
Nodes (21): Array, NSObject, -copyWithArchiver, UIImage, -imageWithView, UIView, -heroID, -heroModifiers (+13 more)

### Community 3 - "Community 3"
Cohesion: 0.07
Nodes (13): BasePreprocessor, -context, -processFromViewstoViews, HeroPlugin, -animateFromViewstoViews, -applyStatetoView, -canAnimateViewappearing, -context (+5 more)

### Community 4 - "Community 4"
Cohesion: 0.08
Nodes (16): HeroContext, -destinationViewForHeroID, -heroIDToDestinationView, -heroIDToSourceView, -hideView, -initWithContainerfromViewtoView, -pairedViewForView, -processViewTreeWithViewcontaineridMapstateMap (+8 more)

### Community 5 - "Community 5"
Cohesion: 0.1
Nodes (11): HeroDefaultAnimator, -animateFromViewstoViews, -animateViewappearing, -applyStatetoView, -canAnimateViewappearing, -context, -resumeForTimereverse, -seekToTime (+3 more)

### Community 6 - "Community 6"
Cohesion: 0.11
Nodes (14): CascadeDirection, bottomToTop, inverseRadial, leftToRight, radial, rightToLeft, topToBottom, CascadePreprocessor (+6 more)

### Community 7 - "Community 7"
Cohesion: 0.11
Nodes (9): BasePreprocessor, IgnoreSubviewModifiersPreprocessor, -processFromViewstoViews, -processViews, MatchPreprocessor, -processFromViewstoViews, SourcePreprocessor, -prepareForViewtargetView (+1 more)

### Community 8 - "Community 8"
Cohesion: 0.13
Nodes (10): HeroTargetState, -appendContentsOfModifiers, -copyWithZone, -customItemOfKey, -delay, -initWithArrayLiteralElements, -initWithModifiers, -setCustomItemOfKeyvalue (+2 more)

### Community 9 - "Community 9"
Cohesion: 0.12
Nodes (15): HeroDefaultAnimatorViewContext, -addAnimationWithKeybeginTimefromValuetoValue, -animateAfterDelay, -applyState, -container, -contentLayer, -currentTime, -distanceFromto (+7 more)

### Community 10 - "Community 10"
Cohesion: 0.13
Nodes (14): UIView, -cornerRadius, -setCornerRadius, -setShadowColor, -setShadowOffset, -setShadowOpacity, -setShadowRadius, -setZPosition (+6 more)

### Community 11 - "Community 11"
Cohesion: 0.14
Nodes (11): CAMediaTimingFunction, -acceleration, -deceleration, -easeIn, -easeInOut, -easeOut, -easeOutBack, -functionFromName (+3 more)

### Community 12 - "Community 12"
Cohesion: 0.15
Nodes (12): ImageGalleryViewController, -cellSize, -collectionViewcellForItemAtIndexPath, -collectionViewdidSelectItemAtIndexPath, -collectionViewlayoutsizeForItemAtIndexPath, -collectionViewnumberOfItemsInSection, -columns, -didReceiveMemoryWarning (+4 more)

### Community 13 - "Community 13"
Cohesion: 0.15
Nodes (12): ScrollingImageCell, -centerIfNeeded, -doubleTap, -image, -initWithCoder, -layoutSubviews, -prepareForReuse, -scrollViewDidZoom (+4 more)

### Community 14 - "Community 14"
Cohesion: 0.17
Nodes (11): ListTableViewController, -didReceiveMemoryWarning, -heroWillStartAnimatingFrom, -heroWillStartAnimatingTo, -numberOfSectionsInTableView, -tableViewcellForRowAtIndexPath, -tableViewdidSelectRowAtIndexPath, -tableViewheightForRowAtIndexPath (+3 more)

### Community 15 - "Community 15"
Cohesion: 0.18
Nodes (10): GridCollectionViewController, -collectionViewcellForItemAtIndexPath, -collectionViewdidSelectItemAtIndexPath, -collectionViewlayoutsizeForItemAtIndexPath, -collectionViewnumberOfItemsInSection, -heroWillStartAnimatingFrom, -heroWillStartAnimatingTo, -numberOfSectionsInCollectionView (+2 more)

### Community 16 - "Community 16"
Cohesion: 0.22
Nodes (8): ImageViewController, -collectionViewcellForItemAtIndexPath, -collectionViewlayoutsizeForItemAtIndexPath, -collectionViewnumberOfItemsInSection, -gestureRecognizerShouldBegin, -pan, -viewDidLoad, -viewWillLayoutSubviews

### Community 17 - "Community 17"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 18 - "Community 18"
Cohesion: 0.29
Nodes (6): CityViewController, -collectionViewcellForItemAtIndexPath, -collectionViewlayoutsizeForItemAtIndexPath, -collectionViewnumberOfItemsInSection, -prepareForSeguesender, -viewDidLoad

### Community 19 - "Community 19"
Cohesion: 0.29
Nodes (6): CityGuideViewController, -collectionViewcellForItemAtIndexPath, -collectionViewnumberOfItemsInSection, -numberOfSectionsInCollectionView, -prepareForSeguesender, -viewDidLoad

### Community 20 - "Community 20"
Cohesion: 0.29
Nodes (6): NSArray, -getBoolAtIndex, -getCGFloatAtIndex, -getDoubleAtIndex, -getFloatAtIndex, -getObjectAtIndex

### Community 22 - "Community 22"
Cohesion: 0.4
Nodes (5): AnyObject, HeroAnimator, HeroPreprocessor, HeroProgressUpdateObserver, HeroViewControllerDelegate

### Community 23 - "Community 23"
Cohesion: 0.4
Nodes (4): ListTableViewCell, -awakeFromNib, -layoutSubviews, -setSelectedanimated

### Community 24 - "Community 24"
Cohesion: 0.4
Nodes (4): ImageLibrary, -count, -imageAtIndex, -thumbnailAtIndex

### Community 25 - "Community 25"
Cohesion: 0.5
Nodes (3): LWViewController, -tableViewdidSelectRowAtIndexPath, -viewDidLoad

### Community 26 - "Community 26"
Cohesion: 0.5
Nodes (3): CityCell, -prepareForReuse, -setCity

## Knowledge Gaps
- **236 isolated node(s):** `-averageColor`, `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive`, `-applicationDidEnterBackground`, `-applicationWillEnterForeground` (+231 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Hero` connect `Community 0` to `Community 3`, `Community 21`?**
  _High betweenness centrality (0.087) - this node is a cross-community bridge._
- **Why does `BasePreprocessor` connect `Community 3` to `Community 7`?**
  _High betweenness centrality (0.067) - this node is a cross-community bridge._
- **Why does `HeroModifier` connect `Community 1` to `Community 3`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **What connects `-averageColor`, `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive` to the rest of the system?**
  _236 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.07 - nodes in this community are weakly interconnected._