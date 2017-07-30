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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.env executePythonScript:@"sys.stdout = open(\"console.txt\", \"a\")"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self _saveConsole];
}

- (void)_saveConsole {
    [self.env executePythonScript:@"sys.stdout.close()"];
    [self.env executePythonScript:@"sys.stdout = open(\"console.txt\", \"a\")"];
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
    [self.env executePythonScript:self.textView.text];
}

@end
