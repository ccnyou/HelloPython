//
//  main.m
//  A main module for starting Python projects under iOS.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char *argv[]) {
    int ret = 0;
    @autoreleasepool {
        ret = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    return ret;
}
