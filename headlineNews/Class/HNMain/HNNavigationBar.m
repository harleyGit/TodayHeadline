//
//  HNNavigationBar.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNavigationBar.h"
#import "HNHeader.h"

@interface HNSearchBar: UITextField

@end

@interface HNActionImageView: UIImageView

@property (nonatomic , copy)void(^imageClickBlock)(void);

@end


@interface HNNavigationBar ()<UITextFieldDelegate>

@end

@implementation HNNavigationBar

+ (instancetype)navigationBar {
    HNNavigationBar *bar = [[HNNavigationBar alloc]initWithFrame:CGRectMake(0, 0, HN_SCREEN_WIDTH, HN_NAVIGATION_BAR_HEIGHT)];
    bar.backgroundColor = [UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1];
    return bar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //左边头像按钮
        HNActionImageView *mineImageView = [[HNActionImageView alloc]init];
        mineImageView.image = [UIImage imageNamed:@"home_no_login_head"];
        [self addSubview:mineImageView];
        @weakify(self);
        [mineImageView setImageClickBlock:^{//点击图片后的Action行为
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HNNavigationBarActionMine);
            }
        }];
        
        HNActionImageView *cameraImageView =  [[HNActionImageView alloc]init];
        cameraImageView.image = [UIImage imageNamed:@"home_camera"];
        [self addSubview:cameraImageView];
        [cameraImageView setImageClickBlock:^{
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HNNavigationBarActionSend);
            }
        }];
        
        
        HNSearchBar *searchBar = [[HNSearchBar alloc]init];
        searchBar.borderStyle = UITextBorderStyleRoundedRect;
        searchBar.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        leftView.image = [UIImage imageNamed:@"searchicon_search_20x20_"];
        searchBar.leftView = leftView;//自定义搜索款，左边的放大镜图片，leftview和rightview，这两个属性分别能设置textField内的左右两边的视图
        searchBar.delegate = self;
        searchBar.text = @"搜你想搜的";
        searchBar.textColor = [UIColor grayColor];
        searchBar.font = [UIFont systemFontOfSize:12];
        searchBar.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:searchBar];
        
        
        [mineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self).offset(-9);
            make.left.mas_equalTo(self).offset(15);
        }];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mineImageView.mas_right).offset(15);
            make.right.mas_equalTo(cameraImageView.mas_left).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);
            make.height.mas_equalTo(26);
        }];
        
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.right.mas_equalTo(self).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);

        }];
        _searchSubjuct = [RACSubject subject];
    }
    return self;
}


#pragma mark - 代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_searchSubjuct sendNext: textField];
    return NO;
}
// 重写适配11
//指定位置后不需设置大小，系统自动调用该方法，使用其size
- (CGSize)intrinsicContentSize {//指控件的内置大小，控件的内置大小往往是由控件本身的内容所决定的，比如一个UILabel的文字很长，那么该UILabel的内置大小自然会很长。设置初始时view的size大小：https://www.jianshu.com/p/3d41981e2282，https://blog.csdn.net/hard_man/article/details/50888377
    return CGSizeMake(HN_SCREEN_WIDTH - 24, 44.f);
}
@end

@implementation HNSearchBar
//设置leftView，搜索框左边(人物头像距离左边的位置)图片的位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {//https://www.jianshu.com/p/f93b005dc9d4
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 8;
    return iconRect;
}
@end

@implementation HNActionImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.imageClickBlock) {
        self.imageClickBlock();//点击图片后触发的行为，很睿智
    }
}
@end
