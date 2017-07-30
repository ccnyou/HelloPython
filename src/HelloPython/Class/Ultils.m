//
// Created by ervinchen on 2017/6/13.
// Copyright (c) 2017 com.tencent.python. All rights reserved.
//

#import "Ultils.h"
#include <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>

static const char *kConsoleFileName = "console.txt";

BOOL IsDebuggerAttached() {
    static BOOL debuggerIsAttached = NO;
    static dispatch_once_t debuggerPredicate;
    dispatch_once(&debuggerPredicate, ^{
        struct kinfo_proc info;
        size_t info_size = sizeof(info);
        int name[4];

        name[0] = CTL_KERN;
        name[1] = KERN_PROC;
        name[2] = KERN_PROC_PID;
        name[3] = getpid();

        if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
            NSLog(@"ERROR: Checking for a running debugger via sysctl() failed: %s", strerror(errno));
            debuggerIsAttached = false;
        }

        if (!debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0)
            debuggerIsAttached = true;
    });

    return debuggerIsAttached;
}

NSString *GetConsolePath() {
    NSURL *appUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                            inDomains:NSUserDomainMask] lastObject];
    NSString *logPath = [[appUrl path] stringByAppendingPathComponent:@(kConsoleFileName)];
    return logPath;
}

NSString *ReadConsole() {
    NSString *logPath = GetConsolePath();
    NSString *content = [[NSString alloc] initWithContentsOfFile:logPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    return content;
}

void ClearConsole() {
    NSString *path = GetConsolePath();
    FILE * fp = fopen([path UTF8String], "w");
    if(fp) {
        fclose(fp);
    }
}
