//
//  UIView+AnimationExtend.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "UIView+AnimationExtend.h"

@implementation UIView (AnimationExtend)
- (CABasicAnimation *)rotationAnimation {
    //指定动画属性
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //
    rotationAnimation.fromValue = @0;
    //结束角度
    rotationAnimation.toValue = @(M_PI * 2.0);
    //动画时间
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    //重复次数
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    return rotationAnimation;
}
- (void)stopRotationAnimation {
    
    if ([self.layer animationForKey:@"rotationAnimation"]) {
        [self.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

@end
