//
//  ViewController.m
//  DecoPlacePick
//
//  Created by 邓奇 on 2018/5/4.
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#import "ViewController.h"
#import "PlacePickMainController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.title = @"选择省市区";
    self.view.backgroundColor = UIColorFromRGB(0xedeff4);
    
    [self setupBtn];
    
}

-(void)setupBtn{
    NSArray *arr = @[@"选择省-市-区",@"选择省-市",@"选择省"];
    for (int i =0; i<arr.count; i++) {
        UIButton *btn = [self buttonWithTitle:arr[i] backgroundColor:[UIColor orangeColor] font:[UIFont systemFontOfSize:15] cornerRadius:3 target:self action:@selector(btnClick:)];
        btn.frame = CGRectMake(10, 50+i*60, ScreenWidth-20, 50);
        btn.tag = i;
        [self.view addSubview:btn];
    }

}
-(void)btnClick:(UIButton *)button{
    MJWeakSelf
    PlacePickMainController *vc = [[PlacePickMainController alloc] init];
    if (button.tag == 0) {
        vc.pickType = PlacePickTypeToCounty;//选择省-市-区
    }else if (button.tag == 1){
        vc.pickType = PlacePickTypeToCity;//选择省-市
    }else{
        vc.pickType = PlacePickTypeToProvince;//选择省
    }
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
    __weak PlacePickMainController *weakVC = vc;
    weakVC.FinishDoneBlock = ^(NSString *selectAllStr, NSString *provinceID, NSString *cityID, NSString *countryID, NSString *holeInfoStr) {
        NSLog(@"%@---%@---%@----%@",provinceID,cityID,countryID,holeInfoStr);
        [button setTitle:holeInfoStr forState:UIControlStateNormal];
    };
}

//仅文字
-(UIButton *)buttonWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font cornerRadius:(NSInteger)cornerRadius target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = backgroundColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (cornerRadius) {//圆角
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
    }
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PlacePickMainController *vc = [[PlacePickMainController alloc] init];
    vc.pickType = PlacePickTypeToCounty;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
