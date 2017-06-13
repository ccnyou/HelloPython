//
//  AppDelegate.m
//  HelloPython
//
//  Created by 聪宁陈 on 2017/6/12.
//  Copyright © 2017年 com.tencent.python. All rights reserved.
//

#import "AppDelegate.h"
#import <PythoniOS/PythoniOS.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PythonEnvironment *env = [PythonEnvironment env];
    [env initialize];
    return YES;
}

@end
