//
//  CustomAlertEvent.m
//  4PL
//
//  Created by 邓奇 on 2018/3/29.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//

#import "CustomAlertEvent.h"


@interface CustomAlertEvent()

@end


@implementation CustomAlertEvent

+(UIAlertController *)aletrViewWithMsg:(NSString *)message andCancelStr:(NSString *)cancelStr andOkStr:(NSString *)okStr andCancelBlock:(void (^)(void))cancelBlock andOkBlock:(void (^)(void))okBlock{
    
    return [CustomAlertEvent aletrViewWithMsg:message andCancelStr:cancelStr andOkStr:okStr andCancelBlock:cancelBlock andOkBlock:okBlock fullTextArr:nil fullColorArr:nil fullFontArr:nil];
}


+(UIAlertController *)aletrViewWithMsg:(NSString *)message andCancelStr:(NSString *)cancelStr andOkStr:(NSString *)okStr andCancelBlock:(void (^)(void))cancelBlock andOkBlock:(void (^)(void))okBlock fullTextArr:(NSArray *)textArr fullColorArr:(NSArray *)colorArr fullFontArr:(NSArray *)fontArr{
    
    UIAlertController* alertC=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelStr.length) {
        UIAlertAction* cameraAction=[UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertC addAction:cameraAction];
    }
    
    if (okStr.length) {
        UIAlertAction* photoAction=[UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alertC addAction:photoAction];
    }
    
    //设置富文本
    [CustomAlertEvent setupAlertController:alertC fullMessage:message TextArr:textArr fullColorArr:colorArr fullFontArr:fontArr];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];;
    return alertC;
}

+(void)setupAlertController:(UIAlertController *)alertController fullMessage:(NSString *)message TextArr:(NSArray *)textArr fullColorArr:(NSArray *)colorArr fullFontArr:(NSArray *)fontArr{
    
    if (!message.length){
        return;
    }
    
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:message];
    
    //设置默认样式--颜色字体大小=
    NSMutableDictionary *defaultAttrDict = [NSMutableDictionary dictionary];
    defaultAttrDict[NSForegroundColorAttributeName] = UIColorFromRGB(0x333333);
    defaultAttrDict[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    NSRange msgRange = [message rangeOfString:message];
    [textAtt addAttributes:defaultAttrDict range:msgRange];

    
    //设置其他富文本
    NSMutableString *muStr = [NSMutableString stringWithString:message];
    for (int i = 0; i<textArr.count; i++) {//5--1
        NSString *text = textArr[i];
        UIColor *color = nil;
        UIFont *font = nil;
        if (fontArr.count) {
            if (i < fontArr.count) {
                font = fontArr[i];
            }
        }
        if (colorArr.count) {
            if (i < colorArr.count) {
                color = colorArr[i];
            }
        }
        NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
        if (color) {
            attrDict[NSForegroundColorAttributeName] = color;
        }
        if (font) {
            attrDict[NSFontAttributeName] = font;
        }
        NSRange range1 = [muStr rangeOfString:text];
        
        [textAtt addAttributes:attrDict range:range1];
        
        
        /*(
         广西,
         柳州,
         广西,
         南宁
         )
         */
        //处理多个相同文本只取第一个文本location的问题
        if (range1.location != NSNotFound) {
            NSInteger length = range1.length;
            NSString *str = @"";
            for (int i =0; i<length; i++) {
                str = [NSString stringWithFormat:@"%@*",str];
            }
            NSString *newStr = [muStr stringByReplacingCharactersInRange:range1 withString:str];
            //            NSString *newStr = [muStr stringByReplacingOccurrencesOfString:text withString:str];
            muStr = [NSMutableString stringWithString:newStr];
        }
    }
    
    
    [alertController setValue:textAtt forKey:@"attributedMessage"];
    
}



@end
