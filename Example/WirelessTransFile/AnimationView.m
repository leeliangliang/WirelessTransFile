//
//  AnimationView.m
//  Test
//
//  Created by Lee on 2019/5/10.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "AnimationView.h"
#import "pop.h"

@interface RhythmAnimationView ()
@property(nonatomic, strong)NSMutableArray *layerArray;
@end
@implementation RhythmAnimationView
- (void)_buildUI
{
    CGFloat xoffset = MAX((self.bounds.size.width - (_numberOfRhythm * _rhythmWidth + (_numberOfRhythm - 1) * _rhythmSpace))/2.f, 0);
    
    CGFloat nSpace = (self.bounds.size.width - _numberOfRhythm * _rhythmWidth - 2 * xoffset) / (_numberOfRhythm - 1);
    
    for (int i = 0; i < self.numberOfRhythm; i++) {
        CALayer *layer = [[CALayer alloc]init];
        layer.position = CGPointMake(xoffset + i * (nSpace + _rhythmWidth), self.bounds.size.height);
        layer.backgroundColor = self.rhythmColor.CGColor;
        
        [self.layerArray addObject:layer];
        
    }
    self.layer removes
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
