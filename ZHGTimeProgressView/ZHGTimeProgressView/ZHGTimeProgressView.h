//
//  ZHGCircleProgressView.h
//  贝塞尔曲线
//
//  Created by DDing_Work on 2017/8/28.
//  Copyright © 2017年 王忠光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHGTimeProgressView : UIView
/** 进度条的线宽 */
@property (nonatomic, assign) CGFloat lineWidth;  //必须设置此属性的值，否则无法显示进度条
/** 扩散圆的的线宽 */
@property (nonatomic, assign) CGFloat extensionLineWidth;


/** 进度条的颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 扩散圆的颜色 */
@property (nonatomic, strong) UIColor *extensionStrokeColor;
/** 背景圆的颜色 */
@property (nonatomic, strong) UIColor *backStrokeColor;
/** 中间区域的填充颜色 */
@property (nonatomic, strong) UIColor *viewFillColor;
/** 扩散圆的填充颜色 */
@property (nonatomic, strong) UIColor *extensionFillColor;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 字体大小 */
@property (nonatomic, assign) CGFloat fontSize;
/** 扩散动画时间:默认 3 秒 */
@property (nonatomic, assign) CGFloat extensionTime;
/** 扩散动画半径：传正数是缩小，负数是扩大，负数绝对值越大，扩散半径越大  */
@property (nonatomic, assign) CGFloat extensionRadius;
/** 进度条的值：[0，1] */
@property (nonatomic, assign) CGFloat progress;

/** 是否每次点击开始进度条都从零开始，default is NO */
@property (nonatomic, assign) BOOL isStartFromZero;
/**
 初始化方法

 @param frame self 的 frame
 @param lineWidth 进度条线宽
 @return self
 */
+(instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth;


/**
 开始
 */
-(void)start;

/**
 暂停
 */
-(void)pause;

/**
 停止
 */
-(void)over;

@end
