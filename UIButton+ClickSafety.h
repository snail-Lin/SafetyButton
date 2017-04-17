//
//  UIButton+ClickSafety.h
//  MethodSwizzling
//
//  Created by 林亦涵 on 2017/4/16.
//  Copyright © 2017年 林亦涵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ClickSafety)
@property (nonatomic, assign) NSTimeInterval clickedTime;
@end
