//
//  ZHGCircleProgressView.m
//  ZHGTimeProgressView
//
//  Created by DDing_Work on 2017/8/28.
//  Copyright © 2017年 DDing_Work. All rights reserved.
//

#import "ZHGTimeProgressView.h"

#define Width self.bounds.size.width
#define Height self.bounds.size.height

#define RGB(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ZHGTimeProgressView ()

{
    NSInteger _count;   //  毫秒总数
    NSInteger _persent; //  毫秒
    NSInteger _second;  //  秒
    NSInteger _minute;  //  分钟
}

/** 背景的layer，默认灰色 */
@property (nonatomic, strong) CAShapeLayer *backLayer;

/**  进度条layer */
@property (nonatomic, strong) CAShapeLayer *circleLayer;

/** 扩散涟漪layer */
@property (nonatomic, strong) CAShapeLayer *extensionLayer;

@property (nonatomic, strong) UILabel      *timeLabel;
@property (nonatomic, strong) NSTimer      *timer;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation ZHGTimeProgressView

#pragma mark - init
+(instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth {
    return [[self alloc] initWithFrame:frame lineWidth:lineWidth];
}

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth{
    self = [super initWithFrame:frame];
    if (self) {
        [self timer];
        _lineWidth = lineWidth;
        [self setupSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self timer];
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    [self addSubview:self.timeLabel];
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.circleLayer];
}

#pragma mark - 懒加载控件
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = self.bounds;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.layer.cornerRadius = self.frame.size.width/2;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.text = @"00:00.00";
        _timeLabel.font = [UIFont systemFontOfSize:30];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

-(CAShapeLayer *)backLayer {
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.path = [self path].CGPath;
        _backLayer.fillColor = [UIColor clearColor].CGColor;
        _backLayer.strokeColor = self.backStrokeColor ? self.backStrokeColor.CGColor : [UIColor lightGrayColor].CGColor;
        _backLayer.lineWidth = self.lineWidth;
        _backLayer.lineCap = kCALineCapRound;
        _backLayer.strokeEnd = 1;
    }
    return _backLayer;
}

-(CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.path = [self path].CGPath;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = self.strokeColor ? self.strokeColor.CGColor : [UIColor greenColor].CGColor;
        _circleLayer.lineWidth = self.lineWidth;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.strokeEnd = 0;
        [self.layer addSublayer:_circleLayer];

    }
    return _circleLayer;
}

-(CAShapeLayer *)extensionLayer {
    if (!_extensionLayer) {
        _extensionLayer = [CAShapeLayer layer];

        _extensionLayer.path = [UIBezierPath bezierPathWithOvalInRect:[self extensionRect]].CGPath;
        _extensionLayer.fillColor = [UIColor clearColor].CGColor;
        _extensionLayer.strokeColor = self.extensionStrokeColor ? self.extensionStrokeColor.CGColor : [UIColor redColor].CGColor;
        _extensionLayer.lineWidth = 5;
        _extensionLayer.lineCap = kCALineCapRound;
    }
    return _extensionLayer;
}

-(UIBezierPath *)path {
    if (!_path) {
        CGFloat centerX = Width / 2;
        CGFloat centerY = Height / 2;
        CGFloat radius = 0;
        if (Width > Height) {
            radius = (Height- self.lineWidth)/2;
        } else if (Width < Height) {
            radius = (Width- self.lineWidth)/2;
        } else {
            radius = (Width - self.lineWidth)/2;
        }
        
        CGPoint point = CGPointMake(centerX, centerY);
        
        _path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:(-0.5 * M_PI) endAngle:(1.5 * M_PI) clockwise:YES];
    }
    return _path;
}

-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

#pragma mark - public method

-(CGRect)extensionRect {
    return CGRectMake(self.timeLabel.frame.origin.x, self.timeLabel.frame.origin.y, Height, Height);
}

- (CGRect)makeEndRect
{
    CGRect endRect = [self extensionRect];
    CGFloat radius = self.extensionRadius ? self.extensionRadius : -100;
    endRect = CGRectInset(endRect, radius, radius);
    return endRect;
}

-(void)extensionWithAnimation {
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:[self extensionRect]];
    
    self.extensionLayer.path = beginPath.CGPath;
    [self.layer insertSublayer:self.extensionLayer below:self.timeLabel.layer];
    
//    CGRect endRect = CGRectInset([self makeEndRect], -100, -100);
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:[self makeEndRect]];
    self.extensionLayer.path = endPath.CGPath;
    self.extensionLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = self.extensionTime ? self.extensionTime : 3.f;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = self.extensionTime ? self.extensionTime : 3.f;
    
    [self.extensionLayer addAnimation:opacityAnimation forKey:@""];
    [self.extensionLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:self.extensionLayer afterDelay:self.extensionTime ? self.extensionTime : 3.f];
    
    [self.circleLayer removeAllAnimations];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
}

-(void)addCAGradientLayer {
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(150,252,153, 1.f) CGColor],(id)[RGB(87, 251, 91, 1.f) CGColor],(id)[RGB(79, 190, 91, 1.f) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_circleLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

#pragma mark -- SEL Action
- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

-(void)timerAction {
    _count++;
    _persent++;
    if (_persent == 100) {
        _second++;
        _persent = 0;
    }
    if (_second == 60) {
        _minute++;
        _second = 0;
    }
    if (_count == 60 * 100) {
        _count = 0;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld.%02ld",_minute,_second,_persent];
    self.progress = 1.0 * _count / (60 * 100) ;

}

//停止计时器
-(void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)pause {
    [self stopTimer];
}

-(void)start {
    if (self.isStartFromZero) {
        [self clearData];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeEnd = 0;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }

    [self.timer setFireDate:[NSDate date]];
}

-(void)over {
    [self stopTimer];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
    [self clearData];
}

-(void)clearData {
    
    self.timeLabel.text = @"00:00.00";
    self.circleLayer.strokeStart = 0;
    self.circleLayer.strokeEnd = 0;
    self.progress = 0;
    _count = 0;
    _minute = 0;
    _second = 0;
    _persent = 0;
}

#pragma mark -- setter 方法

-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.backLayer.lineWidth = lineWidth;
    self.circleLayer.lineWidth = lineWidth;
}

-(void)setExtensionLineWidth:(CGFloat)extensionLineWidth {
    _extensionLineWidth = extensionLineWidth;
    self.extensionLayer.lineWidth = extensionLineWidth;
}

-(void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.circleLayer.strokeColor = strokeColor.CGColor;
}

-(void)setBackStrokeColor:(UIColor *)backStrokeColor {
    _backStrokeColor = backStrokeColor;
    self.backLayer.strokeColor = backStrokeColor.CGColor;
}

-(void)setExtensionStrokeColor:(UIColor *)extensionStrokeColor {
    _extensionStrokeColor = extensionStrokeColor;
    self.extensionLayer.strokeColor = extensionStrokeColor.CGColor;
}

-(void)setViewFillColor:(UIColor *)viewFillColor {
    _viewFillColor = viewFillColor;
    self.timeLabel.backgroundColor = viewFillColor;
}

-(void)setExtensionFillColor:(UIColor *)extensionFillColor {
    _extensionFillColor = extensionFillColor;
    self.extensionLayer.fillColor = extensionFillColor.CGColor;
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.timeLabel.textColor = textColor;
}

-(void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.timeLabel.font = [UIFont systemFontOfSize:fontSize];
}

-(void)setExtensionTime:(CGFloat)extensionTime {
    _extensionTime = extensionTime;
}

-(void)setExtensionRadius:(CGFloat)extensionRadius {
    _extensionRadius = extensionRadius;
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.circleLayer.strokeStart = 0;
    
    if (progress == 0)
        [self extensionWithAnimation];
    else
        self.circleLayer.strokeEnd = progress;
}

@end
