#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BasePreprocessor.h"
#import "CALayer+Hero.h"
#import "CAMediaTimingFunction+Hero.h"
#import "CascadePreprocessor.h"
#import "Hero.h"
#import "HeroContext.h"
#import "HeroDefaultAnimator.h"
#import "HeroDefaultAnimatorViewContext.h"
#import "HeroModifier.h"
#import "HeroPlugin.h"
#import "HeroTargetState.h"
#import "HeroTypes.h"
#import "IgnoreSubviewModifiersPreprocessor.h"
#import "MatchPreprocessor.h"
#import "NSArray+HeroModifier.h"
#import "SourcePreprocessor.h"
#import "UIKit+Hero.h"

FOUNDATION_EXPORT double LWHeroOCVersionNumber;
FOUNDATION_EXPORT const unsigned char LWHeroOCVersionString[];

