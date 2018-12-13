//
//  GHomePrint.m
//  GHomePrintDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHomePrint.h"
typedef NS_ENUM (NSUInteger,GHomePrintButtonType ) {
    /** 全选 */
    GHomePrintButtonTypeSeletedAll = 1,
    /** 关闭 */
    GHomePrintButtonTypeClose ,
};
/** 日志模型 */
@interface GHomePrintModel : NSObject
/** 输出 */
@property (nonatomic, strong) NSString *log;
@property (nonatomic, assign) double timestamp;
@property (nonatomic, copy) NSString *currentTime;

@end
@implementation GHomePrintModel
+ (NSString *)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}
+ (instancetype)creatlogWithText:(NSString *)text {
    GHomePrintModel *printModel = [[GHomePrintModel alloc]init];
    printModel.log = text;
    printModel.timestamp = [[NSDate date] timeIntervalSince1970];
    printModel.currentTime = [self getCurrentTimes];
    return printModel;
}
@end

@interface GHomePrint()<UITextViewDelegate>

@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) NSMutableArray *logs;
/** 容器视图 */
@property (nonatomic , strong) UIView *contentView;

@end
@implementation GHomePrint

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define iPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define GHSafeAreaBottomHeight (iPhoneX ? 34 : 0)
// StatusbarH + NavigationH
#define GHSafeAreaTopHeight (iPhoneX ? 88.f : 64.f)
// StatusBarHeight
#define GHStatusBarHeight (iPhoneX ? 44.f : 20.f)
// NavigationBarHeigth
#define GHNavBarHeight 44.f
// TabBarHeight
#define GHTabBarHeight  (iPhoneX ? (49.f+34.f) : 49.f)

+ (instancetype)sharedManager {
    static GHomePrint *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GHomePrint alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self){
        [self configuration];
        [self setupUI];
        [self show];
    }
    return self;
}

- (void)configuration {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];    
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.textView];

}

- (void)printDict:(NSDictionary *)dict {
    if (dict.count == 0 || dict == nil) {
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *textString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [[GHomePrint sharedManager] printWithNewLog:textString];
    });
}
- (void)printString:(NSString *)textString {
    dispatch_async(dispatch_get_main_queue(),^{
        [[GHomePrint sharedManager] printWithNewLog:textString];
    });
}
- (void)printWithNewLog:(NSString *)newText {
    [self show];
    if (newText.length == 0) {
        return;
    }
    @synchronized (self) {
        newText = [NSString stringWithFormat:@"%@\n", newText];
        [self.logs removeAllObjects];
        GHomePrintModel *printModel = [GHomePrintModel creatlogWithText:newText];
        
        if (printModel == nil) {
            return;
        }
        [self.logs addObject:printModel];
        [self refreshLogDisplay];
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350) * .5, ([UIScreen mainScreen].bounds.size.height -270 ) * .5 - GHSafeAreaTopHeight, 350, 270);
    } completion:^(BOOL finished) {

    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350 ) * .5 , [UIScreen mainScreen].bounds.size.height, 350, 270);
    } completion:^(BOOL finished) {
        [self.layer setOpacity:0.0];
        [self removeFromSuperview];
    }];
}


- (void)refreshLogDisplay {
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    
    for (GHomePrintModel *printModel in self.logs) {
        if (printModel.log.length == 0) {
            return;
        }
        NSString *string = [NSString stringWithFormat:@"%@",printModel.log];
        NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:string];
        [logString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, logString.length)];
        [logString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,logString.length)];

        [attributedString appendAttributedString:logString];
    }
    
    self.textView.attributedText = attributedString;
    if(attributedString.length > 0) {
        NSRange bottom = NSMakeRange(attributedString.length - 1, 1);
        [self.textView scrollRangeToVisible:bottom];

    }
}

- (void)clear {
    self.textView.attributedText = nil;
    self.textView.text = nil;
}

- (void)clickButton: (UIButton *)button {
    
    if (button.tag == GHomePrintButtonTypeSeletedAll) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.textView.text;
        if (pasteboard.string.length) {
            NSLog(@"复制成功");
        }
    } else if (button.tag == GHomePrintButtonTypeClose) {
        [self dismiss];
    }
}
#pragma mark - 懒加载
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350 ) * .5 , [UIScreen mainScreen].bounds.size.height, 350, 270);
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
    }
    return _contentView;
}
- (NSMutableArray *)logs {
    if (_logs == nil) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(10, 10, 350 - 20, 270 - 50 - 20);
        _textView.font = [UIFont systemFontOfSize:20];
        _textView.delegate = self;
        CGFloat width = (350 - 20 - 10)/2;
        NSArray *titles = @[@"一键复制",@"关闭"];
        for (NSInteger index = 0; index < 2; index++) {
            UIButton *button = [[UIButton alloc]init];
            [button setTitle:titles[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(10 * index + index * width + 10, _textView.frame.size.height + _textView.frame.origin.y, width, 50);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            if (index == 0) {
                button.tag = GHomePrintButtonTypeSeletedAll;
            } else {
                button.tag = GHomePrintButtonTypeClose;
            }
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
        }
    }
    return _textView;
}
@end
