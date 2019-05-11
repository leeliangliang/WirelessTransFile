//
//  AnimationView.m
//  Test
//
//  Created by Lee on 2019/5/10.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "AnimationView.h"
#import "POP.h"

@interface RhythmAnimationView ()
@property(nonatomic, strong)NSMutableArray *layerArray;
@end
@implementation RhythmAnimationView



- (void)start{
    [self _buildUI];
}
- (void)_buildUI
{
    CGFloat xoffset = MAX((self.bounds.size.width - (_numberOfRhythm * _rhythmWidth + (_numberOfRhythm - 1) * _rhythmSpace))/2.f, 0);
    
    CGFloat nSpace = (self.bounds.size.width - _numberOfRhythm * _rhythmWidth - 2 * xoffset) / (_numberOfRhythm - 1);
    
    for (int i = 0; i < self.numberOfRhythm; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _rhythmWidth, self.bounds.size.height)];
        view.layer.position = CGPointMake(xoffset + i * (nSpace + _rhythmWidth), self.bounds.size.height);
        view.layer.anchorPoint = CGPointMake(0, 1);
        view.backgroundColor = self.rhythmColor;
        [self addSubview:view];
        //        [self.layerArray addObject:layer];
        
        //        POPBasicAnimation *layerAnimal = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleY];
        //        layerAnimal.fromValue = @(0.5);
        //        layerAnimal.toValue = @(1);
        //        layerAnimal.autoreverses = YES;
        //        layerAnimal.repeatForever = YES;
        //        layerAnimal.duration = 0.12 + arc4random_uniform(10)*0.05;
        //        [view pop_addAnimation:layerAnimal forKey:@"pop_layer_animation"];
        
        CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        base.fromValue = @(0.5);
        base.toValue = @(1);
        base.autoreverses = YES;
        base.repeatCount = NSIntegerMax;
        base.duration = 0.12 + arc4random_uniform(10)*0.05;
        [view.layer addAnimation:base forKey:@"teee"];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
