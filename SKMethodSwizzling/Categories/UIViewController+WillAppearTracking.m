//
//  UIViewController+WillAppearTracking.m
//  SKMethodSwizzling
//
//  Created by Md Adit Hasan on 4/30/16.
//  Copyright © 2016 Md Adit Hasan. All rights reserved.
//

#import "UIViewController+WillAppearTracking.h"
#import <objc/objc-runtime.h>

@implementation UIViewController (WillAppearTracking)

+ (void)load {
    
    static dispatch_once_t onceDispatch;
    
    dispatch_once(&onceDispatch, ^{
        
        Class class = [self class];
        
        SEL mainMethodSEL = @selector(viewWillAppear:);
        SEL swizzledToSEL = @selector(load_viewwillAppear:); //Swizzling
        
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

- (void)load_viewwillAppear:(BOOL)animated {
    
    [self load_viewwillAppear:animated];
    NSLog(@"ViewillAppear");
    // get all touch event in full Application Scope
    
    
}
@end
