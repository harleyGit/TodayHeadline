//
//  HNTabBarController.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//


#import "HNTabBarController.h"
#import "HNNavigationController.h"
#import "HNHomeVC.h"
#import "HNVideoVC.h"
#import "HNMicroHeadlineNewVC.h"
#import "HNMicroVideoVC.h"

#import "HNHeader.h"
#import "UIView+AnimationExtend.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UITabBar+HNTabber.h"
@interface HNTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic , weak)HNNavigationController *homeNav;
@property (nonatomic , weak)UIImageView *swappableImageView;


@end

@implementation HNTabBarController

+ (void)initialize {
    //是否是半透明的
    [[UITabBar appearance] setTranslucent:NO]; //appearance 详解：https://www.jianshu.com/p/90d826315474, https://www.jianshu.com/p/cf9db8bc057c
    //指定 tab bar background.的color
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

    UITabBarItem * item = [UITabBarItem appearance];

    //调节title的位置
    item.titlePositionAdjustment = UIOffsetMake(0, -5);//https://blog.csdn.net/sir_coding/article/details/69895140
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAtts[NSForegroundColorAttributeName] = HN_TABBERBAR_GRAY_COLOR;
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    selectAtts[NSForegroundColorAttributeName] = HN_MIAN_STYLE_COLOR;
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeNav = [self addChildViewControllerWithClass:[HNHomeVC class] imageName:@"home_tabbar_32x32_" selectedImageName:@"home_tabbar_press_32x32_" title:@"首页"];
    [self addChildViewControllerWithClass:[HNVideoVC class] imageName:@"video_tabbar_32x32_" selectedImageName:@"video_tabbar_press_32x32_" title:@"西瓜视频"];
    [self addChildViewControllerWithClass:[HNMicroHeadlineNewVC class] imageName:@"weitoutiao_tabbar_32x32_" selectedImageName:@"weitoutiao_tabbar_press_32x32_" title:@"微头条"];
    [self addChildViewControllerWithClass:[HNMicroVideoVC class] imageName:@"huoshan_tabbar_32x32_" selectedImageName:@"huoshan_tabbar_press_32x32_" title:@"小视频"];
    self.delegate = self;
    
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.tabBar showBadgeOnItemIndex:0 andWithBadgeNumber:15];
    });
     [[RACScheduler mainThreadScheduler]afterDelay:1.5 * 60 schedule:^{
        [self.tabBar showBadgeOnItemIndex:0 andWithBadgeNumber:20];
    }];
    [[HNNotificationCenter rac_addObserverForName:KHomeStopRefreshNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.tabBar hideBadgeOnItemIndex:0];
        if (self.swappableImageView) {
            [self.swappableImageView stopRotationAnimation];
        }
        self.homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabbar_32x32_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabbar_press_32x32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

// 添加子控制器
- (HNNavigationController *)addChildViewControllerWithClass:(Class)class
                              imageName:(NSString *)imageName
                      selectedImageName:(NSString *)selectedImageName
                                  title:(NSString *)title {
    UIViewController *vc = [[class alloc]init];
    HNNavigationController *nav = [[HNNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
    return nav;
}

//should选中viewController  return YES 可以本选中， NO不可以被选中
//双击刷新:https://www.jianshu.com/p/b1e33d73c72e
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.selectedViewController == viewController && self.selectedViewController == _homeNav) {
        //动画:https://www.jianshu.com/p/ed451596a4e1, https://www.jianshu.com/p/e55f059dd748
        //指定动画属性
        if ([_swappableImageView.layer animationForKey:@"rotationAnimation"]) {
            return YES;
        }
        
        //UIImageRenderingModeAlwaysOriginal: 始终绘制图片原始状态，不使用Tint Color
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //双击TabBarItem刷新页面,并且TabBar添加旋转Loading动画
        [self addAnnimation];
    }else {
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabbar_32x32_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabbar_press_32x32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //停止动画
        [_swappableImageView stopRotationAnimation];
    }
    
    if (self.selectedViewController == viewController) {
        HNNavigationController *nav = (HNNavigationController *)viewController;
        if ([nav.viewControllers.firstObject respondsToSelector:@selector(needRefreshTableViewData)]) {
            [nav.viewControllers.firstObject needRefreshTableViewData];
        }
    }
    return YES;
}


- (void)addAnnimation {
    // 这里使用了 私有API 但是审核仍可以通过 有现成的案例, 动画：https://www.jianshu.com/p/b1e33d73c72e
    //获取UITabBarButton的方法
    UIControl *tabBarButton = [_homeNav.tabBarItem valueForKey:@"view"];
    //获取图片的ImageView
    UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
    //添加旋转动画
    [tabBarSwappableImageView rotationAnimation];
    _swappableImageView = tabBarSwappableImageView;
    [self.tabBar hideBadgeOnItemIndex:0];
}

@end
