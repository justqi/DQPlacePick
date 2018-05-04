//
//  PlacePickChildController.h
//  4PL
//
//  Created by 邓奇 on 2018/3/22.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//


/** 展示的控制器类型 */
typedef enum{
    PlaceVcTypeProvince = 1, //省
    PlaceVcTypeCity = 2, //市
    PlaceVcTypeCounty = 3, //区
    PlaceVcTypeOther = 4, //常用
}PlaceVcType;

@interface PlacePickChildController : UIViewController

@property (nonatomic,assign)PlaceVcType type;
@property (strong, nonatomic) void(^BtnClickBlock)(PlaceVcType vcType,NSString *selectInfo);


@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)NSString *selectedInfo;//选中的信息
@property (strong, nonatomic)NSMutableArray *dataArray;

@end
