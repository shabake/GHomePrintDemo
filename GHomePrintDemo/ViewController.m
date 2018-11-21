//
//  ViewController.m
//  GHomePrintDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "ViewController.h"
#import "GHomePrint.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GHomePrint sharedManager] setHidden:NO];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[GHomePrint sharedManager] printString:@"我只是个测试"];
}
@end
