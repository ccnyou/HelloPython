//
//  PythonEnvironment.h
//  PythoniOS
//
//  Created by 聪宁陈 on 2017/6/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PythonEnvironment : NSObject

+ (instancetype)env;

- (BOOL)initialize;

- (void)uninitialize;

- (int)executePythonScript:(NSString *)script;

- (int)executePythonFile:(NSString *)filePath;

@end
