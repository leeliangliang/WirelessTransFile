//
//  LeeViewController.m
//  WirelessTransFile
//
//  Created by 李亮 on 04/24/2019.
//  Copyright (c) 2019 李亮. All rights reserved.
//

#import "LeeViewController.h"
#import "AnimationView.h"

@interface LeeViewController ()

@end

@implementation LeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    return;
    for (int i = 0 ; i < 20; i++) {
        RhythmAnimationView *ani = [[RhythmAnimationView alloc]initWithFrame:CGRectMake(i*50+20, 50, 50, 50)];
        ani.numberOfRhythm = 4;
        ani.rhythmColor = [UIColor redColor];
        ani.rhythmWidth = 5;
        ani.rhythmSpace = 20;
        [self.view addSubview:ani];
//        ani.hidden = YES;
        [ani start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
