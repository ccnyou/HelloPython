//
//  ViewController.m
//  HelloPython
//
//  Created by 聪宁陈 on 2017/6/12.
//  Copyright © 2017年 com.tencent.python. All rights reserved.
//

#import "ViewController.h"
#import <PythoniOS/PythoniOS.h>
#import "Ultils.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) PythonEnvironment *env;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.env = [PythonEnvironment env];
    [self.env executePythonScript:@"import sys"];
    ClearConsole();
    [self _reopenConsole];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self _saveConsole];
}

- (void)_saveConsole {
    [self.env executePythonScript:@"sys.stdout.flush()"];
}

- (void)_reopenConsole {
    const char *code = "sys.stdout = open(\"%@\", \"a\")\n"
    "sys.stderr = sys.stdout";
    NSString *consolePath = GetConsolePath();
    NSString *script = [NSString stringWithFormat:@(code), consolePath];
    [self.env executePythonScript:script];
}

#pragma mark - Action

- (IBAction)executePython:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app/hello" ofType:@"py"];
    PythonEnvironment *env = [PythonEnvironment env];
    [env executePythonFile:path];
}

- (IBAction)onSaveTouched:(id)sender {
    
}

- (IBAction)onExecuteTouched:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app/seed_crawler" ofType:@"py"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.env executePythonFile:path];
        });
    });
    self.textView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
