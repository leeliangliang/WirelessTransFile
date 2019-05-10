//
//  AnimationView.h
//  Test
//
//  Created by Lee on 2019/5/10.
//  Copyright © 2019 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RhythmAnimationView : UIView
@property (nonatomic, assign) NSUInteger numberOfRhythm;
@property (nonatomic, strong) UIColor *rhythmColor;
@property (nonatomic, assign) CGFloat rhythmWidth;
@property (nonatomic, assign) CGFloat rhythmSpace;

@end

NS_ASSUME_NONNULL_END
