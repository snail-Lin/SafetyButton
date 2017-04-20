//
//  UIButton+ClickSafety.m
//  MethodSwizzling
//
//  Created by 林亦涵 on 2017/4/16.
//  Copyright © 2017年 林亦涵. All rights reserved.
//

#import "UIControl+ClickSafety.h"
#import <objc/runtime.h>
@implementation UIControl (ClickSafety)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalS = @selector(sendAction:to:forEvent:);
        SEL swizzledS = @selector(safetySendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(class, originalS);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledS);
        
        
        method_exchangeImplementations(originalMethod, swizzledMethod);

    });
}


- (void)setClickedTime:(NSTimeInterval)clickedTime {
    objc_setAssociatedObject(self, @selector(clickedTime), @(clickedTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)clickedTime {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setIsClicked:(BOOL)isClicked {
    objc_setAssociatedObject(self, @selector(isClicked), @(isClicked), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isClicked {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)safetySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.allTargets.count > 0) {
        [self safetySendAction:action to:target forEvent:event];
        return;
    }
    
    if (self.clickedTime == -1) {
        [self safetySendAction:action to:target forEvent:event];
        return;
    }
    
    if (self.isClicked) {
        return;
    }
    
    self.isClicked = YES;
    
    NSInteger sec = self.clickedTime == 0 ? 0.5 * 1000 : self.clickedTime * 1000;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_MSEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.isClicked = NO;
    });
    
    [self safetySendAction:action to:target forEvent:event];
}
@end
