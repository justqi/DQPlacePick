//
//  PlacePickCell.m
//  4PL
//
//  Created by 邓奇 on 2018/3/22.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//

#import "PlacePickCell.h"

@interface PlacePickCell()


@end

@implementation PlacePickCell

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLB.text = titleStr;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self seutpImageView];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self seutpSubViews];
    }
    return self;
}

-(void)seutpSubViews{
    self.layer.cornerRadius = 3;
    self.titleLB = [self labelWithCenterText:@"" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15.0]];
    self.titleLB.numberOfLines = 2;
    [self addSubview:self.titleLB];
    self.titleLB.frame = CGRectMake(0, 0, self.width, self.height);
}

//创建文字居中的lable(未设置frame)
-(UILabel *)labelWithCenterText:(NSString *)text color:(UIColor *)textcolor font:(UIFont *)font
{
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text=text;
    label.textColor=textcolor;
    label.font=font;
    [label sizeToFit];//宽高自适应文字
    return label;
}


@end
