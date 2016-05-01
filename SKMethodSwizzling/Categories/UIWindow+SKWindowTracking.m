//
//  UIWindow+SKWindowTracking.m
//  SKMethodSwizzling
//
//  Created by Md Adit Hasan on 4/29/16.
//  Copyright © 2016 Md Adit Hasan. All rights reserved.
//

#import "UIWindow+SKWindowTracking.h"
#import <objc/objc-runtime.h>

@implementation UIWindow (SKWindowTracking)

+ (void)load {
    
    static dispatch_once_t onceDispatch;
    
    dispatch_once(&onceDispatch, ^{
        
        Class class = [self class];
        
        SEL mainMethodSEL = @selector(sendEvent:);
        SEL swizzledToSEL = @selector(get_touchEvent:);
        
        // the method we are going to swizzle
        Method mainMethod = class_getInstanceMethod(class, mainMethodSEL);
        // the method we are going to swizzle to
        Method swizzledTo = class_getInstanceMethod(class, swizzledToSEL);

        BOOL addMethod = class_addMethod(class, mainMethodSEL, method_getImplementation(swizzledTo),method_getTypeEncoding(swizzledTo));
        if (addMethod) {
            class_replaceMethod(class, swizzledToSEL, method_getImplementation(mainMethod),method_getTypeEncoding(mainMethod));
        } else {
            method_exchangeImplementations(mainMethod, swizzledTo);
        }
        
    });
    
}



#pragma mark - Method Swizzling



- (void)get_touchEvent:(UIEvent *)event {
    
    [self get_touchEvent:event];
    
    // get all touch event in full Application Scope
    
    
}
@end
