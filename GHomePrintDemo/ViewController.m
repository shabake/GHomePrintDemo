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
    [[GHomePrint sharedManager] printString:@"不过美国贸易委员会(ITC)表示，希望高通与苹果能够采取妥协措施，因为该进口禁令将伤害美国在下一代5G移动技术发展过程中的竞争优势。并希望保护美国公司在下一代手机技术领域的主导地位。12 月 9 日，高通宣布，福州市中级人民法院判定苹果侵犯了高通的两项软件专利，包括了在触摸屏上调整照片大小和管理应用程序"];
 
}
@end
