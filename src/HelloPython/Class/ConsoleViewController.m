//
//  ConsoleViewController.m
//  HelloPython
//
//  Created by ervinchen on 2017/6/13.
//  Copyright © 2017年 com.tencent.python. All rights reserved.
//

#import "ConsoleViewController.h"
#import "Ultils.h"

@interface ConsoleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.textView.text = ReadConsole();
}

- (IBAction)onClearTouched:(id)sender {
    ClearConsole();
    self.textView.text = @"";
}

@end
