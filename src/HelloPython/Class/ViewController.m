//
//  ViewController.m
//  HelloPython
//
//  Created by 聪宁陈 on 2017/6/12.
//  Copyright © 2017年 com.tencent.python. All rights reserved.
//

#import "ViewController.h"
#import <PythoniOS/PythoniOS.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) PythonEnvironment *env;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.env = [PythonEnvironment env];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSaveTouched:(id)sender {
}

- (IBAction)onExecuteTouched:(id)sender {
    [self.env executePythonScript:self.textView.text];
}

@end
