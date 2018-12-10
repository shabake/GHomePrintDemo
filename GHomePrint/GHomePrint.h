//
//  GHomePrint.h
//  GHomePrintDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GHomePrint : UIWindow

+ (instancetype)sharedManager;

/** 打印log (String 类型) */
- (void)printString:(NSString *)textString;
/** 打印log (NSDictionary 类型) */
- (void)printDict:(NSDictionary *)dict;
/** 清除所有数据 */
- (void)clear;
@end

NS_ASSUME_NONNULL_END
