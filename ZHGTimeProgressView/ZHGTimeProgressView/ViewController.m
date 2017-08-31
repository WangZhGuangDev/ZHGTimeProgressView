//
//  ViewController.m
//  ZHGTimeProgressView
//
//  Created by DDing_Work on 2017/8/31.
//  Copyright © 2017年 DDing_Work. All rights reserved.
//

#import "ViewController.h"
#import "ZHGTimeProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ZHGTimeProgressView *timeProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.timeProgressView];
}

- (IBAction)begin:(UIButton *)sender {
    NSLog(@"点击了开始");
    [self.timeProgressView start];
    
}
- (IBAction)pause:(UIButton *)sender {
    NSLog(@"点击了暂停");
    [self.timeProgressView pause];
    
}
- (IBAction)over:(UIButton *)sender {
    NSLog(@"点击了完成");
    [self.timeProgressView over];
}

-(ZHGTimeProgressView *)timeProgressView {
    if (!_timeProgressView) {
        _timeProgressView = [ZHGTimeProgressView initWithFrame:(CGRectMake(50, self.view.center.y - 100, 300, 300)) lineWidth:10];
        //        _timeProgressView.backStrokeColor = [UIColor redColor];
        //        _timeProgressView.strokeColor = [UIColor blueColor];
        //        _timeProgressView.extensionStrokeColor = [UIColor yellowColor];
        //
        //        _timeProgressView.viewFillColor = [UIColor cyanColor];
        //        _timeProgressView.extensionFillColor = [UIColor grayColor];
        //        _timeProgressView.extensionTime = 1;
        //        _timeProgressView.extensionRadius = -20;
        //        _timeProgressView.isStartFromZero = YES;
    }
    return _timeProgressView;
}

@end
