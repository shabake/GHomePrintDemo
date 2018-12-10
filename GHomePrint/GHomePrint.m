//
//  GHomePrint.m
//  GHomePrintDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHomePrint.h"

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

@interface GHomePrint()

@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) NSMutableArray *logs;

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
    
    self = [super initWithFrame:CGRectMake(0, GHStatusBarHeight, kScreenWidth, kScreenHeight - GHStatusBarHeight)];
    if (self){
        [self configuration];
        [self setupUI];
        [self show];
    }
    return self;
}

- (void)configuration {
    self.windowLevel = UIWindowLevelAlert;
    self.userInteractionEnabled = NO;
}
- (void)setupUI {
    [self addSubview:self.textView];
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
    if (newText.length == 0) {
        return;
    }
    @synchronized (self) {
        newText = [NSString stringWithFormat:@"%@\n", newText];
        GHomePrintModel *printModel = [GHomePrintModel creatlogWithText:newText];
        
        if (printModel == nil) {
            return;
        }
        [self.logs addObject:printModel];
        [self refreshLogDisplay];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
- (void)show {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.textView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350) * .5, ([UIScreen mainScreen].bounds.size.height -350 ) * .5 - GHSafeAreaTopHeight, 350, 350);

    } completion:^(BOOL finished) {

    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.textView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350 ) * .5 , [UIScreen mainScreen].bounds.size.height, 350, 350);
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)refreshLogDisplay {
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    
    for (GHomePrintModel *printModel in self.logs) {
        if (printModel.log.length == 0) {
            return;
        }
        NSString *string = [NSString stringWithFormat:@"%@ %@",printModel.currentTime,printModel.log];
        NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:string];
        [logString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, logString.length)];

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

- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - 懒加载
- (NSMutableArray *)logs {
    if (_logs == nil) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor redColor];
        _textView.scrollsToTop = NO;
        _textView.text = @"点击";
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.layer.shadowColor = [UIColor blackColor].CGColor;
        _textView.layer.shadowOffset = CGSizeMake(0, -3);
        _textView.layer.shadowOpacity = 0.41;
        _textView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -350 ) * .5 , [UIScreen mainScreen].bounds.size.height, 350, 350);
    }
    return _textView;
}
@end
