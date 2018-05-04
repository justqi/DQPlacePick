//
//  PlacePickMainController.h
//  4PL
//
//  Created by 邓奇 on 2018/3/22.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//


/** 选择省市区类型 */
typedef enum{
    PlacePickTypeToProvince = 2, //包括--常用-省
    PlacePickTypeToCity = 3, //包括--常用-省-市
    PlacePickTypeToCounty = 4, //包括--常用-省-市-区
}PlacePickType;



@interface PlacePickMainController : UIViewController

@property (nonatomic,assign)PlacePickType pickType;//设置需要展示的类型
@property (nonatomic,assign)BOOL showAllProvince;//是否显示全国（默认不显示）
@property (nonatomic,assign)BOOL showAllCity;//是否显示全部城市(默认不显示）
@property (nonatomic,assign)BOOL showAllCountry;//是否显示全部地区（默认不显示）


//两种block回调方式

@property (strong, nonatomic) void(^FinishBtnClickBlock)(NSString *selectAllStr,NSString *provinceInfo,NSString *cityInfo,NSString *countryInfo);//确定后回调  对应格式  --  29;广西  29318;南宁市  293182975;青秀区

@property (strong, nonatomic) void(^FinishDoneBlock)(NSString *selectAllStr,NSString *provinceID,NSString *cityID,NSString *countryID,NSString *holeInfoStr);//确定后回调  对应格式  --  29  29318  293182975    广西南宁市青秀区

@end
