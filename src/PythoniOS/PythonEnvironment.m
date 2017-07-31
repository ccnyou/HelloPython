//
//  PythonEnvironment.m
//  PythoniOS
//
//  Created by 聪宁陈 on 2017/6/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "PythonEnvironment.h"
#include "Python.h"
#include <dlfcn.h>

@implementation PythonEnvironment {
    wchar_t *_python_home;
}

+ (instancetype)env {
    static PythonEnvironment *env = nil;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        env = [[PythonEnvironment alloc] init];
    });
    return env;
}

- (BOOL)initialize {
    NSString *tmp_path;
    NSString *python_home;
    NSString *python_path;
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];

    // Special environment to prefer .pyo; also, don't write bytecode
    // because the process will not have write permissions on the device.
    putenv("PYTHONOPTIMIZE=1");
    putenv("PYTHONDONTWRITEBYTECODE=1");

    // Set the home for the Python interpreter
    python_home = [NSString stringWithFormat:@"%@/Library/Python.framework/Resources", resourcePath];
    //NSLog(@"PythonHome is: %@", python_home);
    _python_home = Py_DecodeLocale([python_home UTF8String], NULL);
    Py_SetPythonHome(_python_home);

    // Set the PYTHONPATH
    python_path = [NSString stringWithFormat:@"PYTHONPATH=%@/app:%@/app_packages:%@/site_packages", resourcePath, resourcePath, resourcePath];
    //NSLog(@"PYTHONPATH is: %@", python_path);
    putenv((char *)[python_path UTF8String]);

    // iOS provides a specific directory for temp files.
    tmp_path = [NSString stringWithFormat:@"TMP=%@/tmp", resourcePath];
    putenv((char *)[tmp_path UTF8String]);

    //NSLog(@"Initializing Python runtime");
    Py_Initialize();
    
    // set argv
    wchar_t *argv[] = {L"PythoniOS"};
    PySys_SetArgv(1, argv);
    
    // If other modules are using threads, we need to initialize them.
    PyEval_InitThreads();
    
    // init cwd
    static const char *setCwdScrppt = "import os\n"
    "os.chdir(\"%@\")";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSString *command = [NSString stringWithFormat:@(setCwdScrppt), docPath];
    [self executePythonScript:command];
    NSLog(@"%s %d cwd = %@", __FUNCTION__, __LINE__, docPath);
    
    return YES;
}

- (void)uninitialize {
    Py_Finalize();
    PyMem_RawFree(_python_home);
}

- (int)executePythonScript:(NSString *)script {
    int ret = PyRun_SimpleString([script UTF8String]);
    return ret;
}

- (int)executePythonFile:(NSString *)filePath {
    int ret = -1;
    const char *szFilePath = [filePath UTF8String];
    FILE *fd = fopen(szFilePath, "r");
    if (fd) {
        ret = PyRun_SimpleFileEx(fd, szFilePath, 1);
        if (ret != 0) {
            NSLog(@"Application quit abnormally!");
        }
        fclose(fd);
    }
    return ret;
}

@end
