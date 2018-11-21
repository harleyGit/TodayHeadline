//
//  HNHomeTitleViewModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNBaseViewModel.h"

@interface HNHomeTitleViewModel : HNBaseViewModel
//第三方框架 ReactiveCocoa
@property (nonatomic , strong) RACCommand *titlesCommand;

@end
