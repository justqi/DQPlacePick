//
//  CustomAlertEvent.h
//  4PL
//
//  Created by 邓奇 on 2018/3/29.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAlertEvent : NSObject


+(UIAlertController *)aletrViewWithMsg:(NSString *)message andCancelStr:(NSString *)cancelStr andOkStr:(NSString *)okStr andCancelBlock:(void (^)(void))cancelBlock andOkBlock:(void (^)(void))okBlock;


/** @brief  设置弹框的富文本
 * @param  textArr 要设置的文字数组
 * @param  colorArr 要设置的文字对应的颜色数组，为nil使用默认
 * @param  fontArr 要设置的文字对应的字体数组，为nil使用默认
 * @return CustomAlertEvent
 */
+(UIAlertController *)aletrViewWithMsg:(NSString *)message andCancelStr:(NSString *)cancelStr andOkStr:(NSString *)okStr andCancelBlock:(void (^)(void))cancelBlock andOkBlock:(void (^)(void))okBlock fullTextArr:(NSArray *)textArr fullColorArr:(NSArray *)colorArr fullFontArr:(NSArray *)fontArr;


/* 例子
 NSArray *textArr = @[@"对应",@"稍后",@"稍后"];
 NSArray *colorArr = @[Color_edeff4,Color_ff0000,Color_999999];
 NSArray *fontArr = @[UIFont_18,UIFont_36,UIFont_24];
 AlertShowWithFullMessage(@"为找到对应的签收类型，请稍后再试,稍后再说", @"取消", @"确定", nil, nil, textArr, colorArr,fontArr);
 */

//或者使用此方法设置富文本
+(void)setupAlertController:(UIAlertController *)alertController fullMessage:(NSString *)message TextArr:(NSArray *)textArr fullColorArr:(NSArray *)colorArr fullFontArr:(NSArray *)fontArr;

@end
