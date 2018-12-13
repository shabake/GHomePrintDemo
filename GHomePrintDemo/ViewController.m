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
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[GHomePrint sharedManager] printString:@"asdasda阿善动安徽省地阿斯顿还是得安顺达四大还哦的按时代会上到山顶啊师大会受到"];
 

}
@end
