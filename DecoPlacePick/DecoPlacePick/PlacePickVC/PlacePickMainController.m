//
//  PlacePickMainController.m
//  4PL
//
//  Created by 邓奇 on 2018/3/22.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//

#import "PlacePickMainController.h"
#import "PlacePickChildController.h"

@interface PlacePickMainController ()<UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (strong, nonatomic) UIView *indicatorView;
/** 当前选中的按钮 */
@property (strong, nonatomic) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (strong, nonatomic) UIView *titlesView;
/** 底部的所有内容 */
@property (strong, nonatomic) UIScrollView *contentView;

@property (nonatomic,assign)NSInteger curentIndex;

@property (strong, nonatomic)NSComparator cmptr;//排序用

@property (strong, nonatomic)NSMutableDictionary *dataSourceDic;//所有省市区的数据
@property (strong, nonatomic)NSMutableArray *commonUseArr;
@property (strong, nonatomic)NSMutableArray *provinceArr;//省分数据
@property (strong, nonatomic)NSMutableArray *cityArr;//城市数据
@property (strong, nonatomic)NSMutableArray *countryArr;//地区数据

@property (strong, nonatomic)NSString *provinceInfo;//选择后的省份信息
@property (strong, nonatomic)NSString *cityInfo;//选择后的城市信息
@property (strong, nonatomic)NSString *countryInfo;//选择后的地区信息
@property (strong, nonatomic)NSString *commonUseInfo;//选择后的常用信息

@property (nonatomic,assign)PlaceVcType currentVcType;//当前控制器类型
@property (nonatomic,assign)NSString *selectAllStr;//选择了全部

@end

static NSString *KallProvinceStr = @"2008001;全国";
static NSString *KallCityStr = @"2008002;全部城市";
static NSString *KallCountryStr = @"2008003;全部地区";

@implementation PlacePickMainController

-(void)viewWillAppear:(BOOL)animated{
    UIViewController *childVC = self.childViewControllers[self.curentIndex];
    NSString *title = childVC.title;
    self.title = title;
    
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickType = self.pickType ? self.pickType : PlacePickTypeToCounty;//未设置选择的类型就默认到省市区
    [self initDataWithType:PlaceVcTypeProvince];//初始化省份数据
    [self initHistoryData];//初始化历史记录
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 底部的scrollView
    [self setupContentView];
    
    [self setupNaviView];
    
    self.view.backgroundColor = UIColorFromRGB(0xedeff4);
    
}
-(void)setupNaviView{

    self.title = @"请选择";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.size = CGSizeMake(60, 30);
    [button addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:button];
}

//完成后返回事件
-(void)finishPopViewEven{
    MJWeakSelf
    if (self.FinishBtnClickBlock) {
        weakSelf.FinishBtnClickBlock(weakSelf.selectAllStr,weakSelf.provinceInfo, weakSelf.cityInfo, weakSelf.countryInfo);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }else if (self.FinishDoneBlock){
        NSString *privinceID = nil;
        NSString *cityID = nil;
        NSString *coutryID = nil;
        NSString *holeInfoStr = nil;
        if (self.provinceInfo) {
            NSArray *arr = [self.provinceInfo componentsSeparatedByString:@";"];
            privinceID = arr[0];
            holeInfoStr = [NSString stringWithFormat:@"%@",arr[1]];
        }
        if (self.cityInfo) {
            NSArray *arr = [self.cityInfo componentsSeparatedByString:@";"];
            cityID = arr[0];
            holeInfoStr = [NSString stringWithFormat:@"%@%@",holeInfoStr,arr[1]];
        }
        if (self.countryInfo) {
            NSArray *arr = [self.countryInfo componentsSeparatedByString:@";"];
            coutryID = arr[0];
            holeInfoStr = [NSString stringWithFormat:@"%@%@",holeInfoStr,arr[1]];
        }
        weakSelf.FinishDoneBlock(self.selectAllStr, privinceID, cityID, coutryID, holeInfoStr);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.currentVcType == PlaceVcTypeOther || self.selectAllStr.length) {
        return;//点击的是常用，全部，不必保存
    }
    //保存历史数据
    [self setupHistoryData];
}

-(void)rightButtonClick:(UIButton *)button{

    if (self.pickType == PlacePickTypeToProvince){
        if (!self.provinceInfo.length) {
            AlertShowWithMessage(@"需要选择到省份", @"确定", nil, nil, nil);
            return;
        }
    }else if (self.pickType == PlacePickTypeToCity){
        if (!self.provinceInfo.length || !self.cityInfo.length) {
            AlertShowWithMessage(@"需要选择到城市", @"确定", nil, nil, nil);
            return;
        }
    }else{
        if (!self.provinceInfo.length || !self.cityInfo.length || !self.countryInfo.length) {
//            if (!self.countryArr.count) {
//
//            }
            AlertShowWithMessage(@"需要选择到区", @"确定", nil, nil, nil);
            return;
        }
    }
    [self finishPopViewEven];//返回前一控制器

}

#pragma mark - **************** 初始化历史记录
-(void)initHistoryData{
    if (self.pickType == PlacePickTypeToProvince) {
        NSArray *arr = ZXUserDefaultObjectForKey(UserDataHistoryProvince);
        self.commonUseArr = [NSMutableArray arrayWithArray:arr];
    }else if (self.pickType == PlacePickTypeToCity){
        NSArray *arr = ZXUserDefaultObjectForKey(UserDataHistoryProCity);
        self.commonUseArr = [NSMutableArray arrayWithArray:arr];
    }else{
        NSArray *arr = ZXUserDefaultObjectForKey(UserDataHistoryProCityCountry);
        self.commonUseArr = [NSMutableArray arrayWithArray:arr];
    }
    
}

-(void)setupHistoryData{
    if (self.pickType == PlacePickTypeToProvince) {
        //保存仅仅选择省份的数据
        NSString *dataStr = [NSString stringWithFormat:@"%@",self.provinceInfo];
        [self setupSaveMaxCount:dataStr];
        ZXUserDefaultSetObjectForKey(self.commonUseArr, UserDataHistoryProvince);
    }
    else if (self.pickType == PlacePickTypeToCity)
    {
        //处理保存仅仅选择省市的数据
        NSArray *province = [self.provinceInfo componentsSeparatedByString:@";"];//29;广西
        NSArray *city = [self.cityInfo componentsSeparatedByString:@";"];//29319;柳州市
        
        NSString *newProvinceInfo = [self.provinceInfo stringByReplacingOccurrencesOfString:@";" withString:@"-"];//29-广西
        NSString *newCityInfo = [self.cityInfo stringByReplacingOccurrencesOfString:@";" withString:@"-"];//29319-柳州市
        NSString *provinceName = province[1];
        NSString *cityName = city[1];

        NSString *dataStr = [NSString stringWithFormat:@"%@,%@;%@%@",newProvinceInfo,newCityInfo,provinceName,cityName];//29-广西,29319-柳州市;广西柳州市
        [self setupSaveMaxCount:dataStr];
        
        ZXUserDefaultSetObjectForKey(self.commonUseArr, UserDataHistoryProCity);
    }
    else if (self.pickType == PlacePickTypeToCounty)
    {
        //处理保存选择到省市区的数据
        NSArray *province = [self.provinceInfo componentsSeparatedByString:@";"];//29;广西
        NSArray *city = [self.cityInfo componentsSeparatedByString:@";"];//29319;柳州市

        NSString *newProvinceInfo = [self.provinceInfo stringByReplacingOccurrencesOfString:@";" withString:@"-"];//29-广西
        NSString *newCityInfo = [self.cityInfo stringByReplacingOccurrencesOfString:@";" withString:@"-"];//29319-柳州市
        NSString *provinceName = province[1];
        NSString *cityName = city[1];
        
        //处理香港，澳门没有区的情况
        NSString *newCountryInfo = nil;
        NSString *countryName = nil;
        if (self.countryInfo) {
            NSArray *country = [self.countryInfo componentsSeparatedByString:@";"];//293192987;鱼峰区
            newCountryInfo = [self.countryInfo stringByReplacingOccurrencesOfString:@";" withString:@"-"];//293192987;鱼峰区
            countryName = country[1];
        }
        NSString *dataStr = nil;
        if (newCountryInfo && countryName) {
           dataStr = [NSString stringWithFormat:@"%@,%@,%@;%@%@%@",newProvinceInfo,newCityInfo,newCountryInfo,provinceName,cityName,countryName];//29-广西,29319-柳州市,293192987-鱼峰区;广西柳州市鱼峰区
        }else{
            dataStr = [NSString stringWithFormat:@"%@,%@;%@%@",newProvinceInfo,newCityInfo,provinceName,cityName];//29-澳门,29319-澳门-鱼峰区;澳门澳门
        }

        [self setupSaveMaxCount:dataStr];
        
        ZXUserDefaultSetObjectForKey(self.commonUseArr, UserDataHistoryProCityCountry);
    }

}

//最多保存十个历史记录
-(void)setupSaveMaxCount:(NSString *)dataStr{
    BOOL flag = YES;
    for (int i=0; i<self.commonUseArr.count; i++) {
        if ([dataStr isEqualToString:self.commonUseArr[i]]) {
            flag = NO;
        }
    }
    if (flag) {
        [self.commonUseArr insertObject:dataStr atIndex:0];
    }
    int count = (int)self.commonUseArr.count;
    while (count>10) {
        [self.commonUseArr removeLastObject];
        count--;
    }
}


-(void)initDataWithType:(PlaceVcType)type{
    
    //排序
    NSComparator cmptr = ^(id obj1, id obj2){//元素格式--10;北京
        NSInteger place1 = [[[obj1 componentsSeparatedByString:@";"]objectAtIndex:0]integerValue];
        NSInteger place2 = [[[obj2 componentsSeparatedByString:@";"]objectAtIndex:0]integerValue];
        if (place1 > place2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (place1 < place2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    self.cmptr = cmptr;
    

    NSString *path = [[NSBundle mainBundle] pathForResource:UDFDictGeography ofType:@"plist"];
    self.dataSourceDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    ZXUserDefaultSetObjectForKey(self.dataSourceDic, UDFDictGeography);
    
    //初始化省份数据
    if (type == PlaceVcTypeProvince) {
        NSArray *oldProvinceArr = [self.dataSourceDic allKeys];//元素格式--10;北京
        self.provinceArr = [[NSMutableArray alloc]initWithArray:[oldProvinceArr sortedArrayUsingComparator:cmptr]];
        if (self.showAllProvince) {
            NSString *allProvince = KallProvinceStr;
            [self.provinceArr insertObject:allProvince atIndex:0];
        }
        
    }
    else if (type == PlaceVcTypeCity){
        
        self.cityInfo = self.countryInfo = nil;
    //初始化城市数据
        NSString *dataStr = self.provinceInfo;//10;北京
        NSDictionary *cityDict = self.dataSourceDic[dataStr];
        NSArray *cityArr = [cityDict.allKeys sortedArrayUsingComparator:self.cmptr];
        [self.cityArr removeAllObjects];
        [self.cityArr addObjectsFromArray:cityArr];
        if (self.showAllCity) {
            NSString *allCity = KallCityStr;
            [self.cityArr insertObject:allCity atIndex:0];
        }
        
        
    }else if (type == PlaceVcTypeCounty){
        
        self.countryInfo = nil;
    //初始化地区数据
        NSString *dataStr = self.provinceInfo;//10;北京
        NSString *cityStr = self.cityInfo;//10;北京
        NSDictionary *cityDict = self.dataSourceDic[dataStr];
        NSDictionary *countryDict = cityDict[cityStr];
        NSArray *oldCountryArr = [countryDict allKeys];//元素格式--10;北京
        self.countryArr = [[NSMutableArray alloc]initWithArray:[oldCountryArr sortedArrayUsingComparator:cmptr]];
        if (self.showAllCountry) {
            NSString *allCountry = KallCountryStr;
            [self.countryArr insertObject:allCountry atIndex:0];
        }
    }
}


/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    PlacePickChildController *firstVc = [[PlacePickChildController alloc] init];
    firstVc.title = @"常用";
    firstVc.type = PlaceVcTypeOther;
    PlacePickChildController *secondVc = [[PlacePickChildController alloc] init];
    secondVc.title = @"省份";
    secondVc.type = PlaceVcTypeProvince;
    PlacePickChildController *thirdVc = [[PlacePickChildController alloc] init];
    thirdVc.title = @"城市";
    thirdVc.type = PlaceVcTypeCity;
    PlacePickChildController *fourthVc = [[PlacePickChildController alloc] init];
    fourthVc.title = @"地区";
    fourthVc.type = PlaceVcTypeCounty;

    if (self.pickType  == PlacePickTypeToProvince) {
        [self addChildViewController:firstVc];
        [self addChildViewController:secondVc];
    }else if (self.pickType == PlacePickTypeToCity){
        [self addChildViewController:firstVc];
        [self addChildViewController:secondVc];
        [self addChildViewController:thirdVc];
    }else{
        [self addChildViewController:firstVc];
        [self addChildViewController:secondVc];
        [self addChildViewController:thirdVc];
        [self addChildViewController:fourthVc];
    }
    
    #pragma mark - **************** 点击确定的回调事件
    NSArray *vcArr = @[firstVc,secondVc,thirdVc,fourthVc];
    for (int i = 0; i<vcArr.count; i++) {
        PlacePickChildController *childVC = vcArr[i];
        
        childVC.BtnClickBlock = ^(PlaceVcType vcType,NSString *selectInfo) {
            
            if ([selectInfo isEqualToString:KallProvinceStr] || [selectInfo isEqualToString:KallCityStr] || [selectInfo isEqualToString:KallCountryStr]) {
                self.selectAllStr = selectInfo;
                [self finishPopViewEven];//返回前一控制器
                return ;
            }
            
            self.currentVcType = vcType;
            // 点击按钮
            NSInteger index = self.contentView.contentOffset.x / self.contentView.width;
            
            if (vcType == PlaceVcTypeProvince) {
                self.provinceInfo = selectInfo;
                if (self.pickType == PlacePickTypeToProvince) {
                    [self finishPopViewEven];//返回前一控制器
                    return ;
                }
                [self initDataWithType:PlaceVcTypeCity];
            }else if (vcType == PlaceVcTypeCity){
                self.cityInfo = selectInfo;
                [self initDataWithType:PlaceVcTypeCounty];
                if (self.pickType == PlacePickTypeToCity || !self.countryArr.count) {//香港，澳门，没有区的
                    [self finishPopViewEven];//返回前一控制器
                    return ;
                }
                
            }else if (vcType == PlaceVcTypeCounty){
                self.countryInfo = selectInfo;
                [self finishPopViewEven];//返回前一控制器
                return ;
            }else if (vcType == PlaceVcTypeOther){
                self.commonUseInfo = selectInfo;//29-广西,29319-柳州市,293192987-鱼峰区;广西柳州市鱼峰区
                [self setupProvinceCityCountryData];
                return ;
            }
            if (self.curentIndex+1 >= self.childViewControllers.count) {
                return ;
            }
            self.curentIndex = index+1;
            [self titleClick:self.titlesView.subviews[self.curentIndex]];
        };
        
    }
}

//点击常用后根据类型给省市区赋值
-(void)setupProvinceCityCountryData{
    if (self.pickType == PlacePickTypeToProvince) {
        
        //格式: 29;广西
        self.provinceInfo = self.commonUseInfo;
        
    }else if (self.pickType == PlacePickTypeToCity){
        
        //格式: 29-广西,29319-柳州市;广西柳州市
        NSArray *arr = [self.commonUseInfo componentsSeparatedByString:@";"];
        NSString *proCityInfo = arr[0];
        NSArray *proCityArr = [proCityInfo componentsSeparatedByString:@","];
        NSString *provinceInfo = proCityArr[0];
        NSString *cityInfo = proCityArr[1];
        self.provinceInfo = [provinceInfo stringByReplacingOccurrencesOfString:@"-" withString:@";"];
        self.cityInfo = [cityInfo stringByReplacingOccurrencesOfString:@"-" withString:@";"];
        
    }else {
        
        //格式: 29-广西,29319-柳州市,293192987-鱼峰区;广西柳州市鱼峰区
        NSArray *arr = [self.commonUseInfo componentsSeparatedByString:@";"];
        NSString *proCityCuntryInfo = arr[0];
        NSArray *proCityCountryArr = [proCityCuntryInfo componentsSeparatedByString:@","];
        NSString *provinceInfo = proCityCountryArr[0];
        NSString *cityInfo = proCityCountryArr[1];
        self.provinceInfo = [provinceInfo stringByReplacingOccurrencesOfString:@"-" withString:@";"];
        self.cityInfo = [cityInfo stringByReplacingOccurrencesOfString:@"-" withString:@";"];
        if (proCityCountryArr.count>=3) {//香港澳门没有区
            NSString *countryInfo = proCityCountryArr[2];
            self.countryInfo = [countryInfo stringByReplacingOccurrencesOfString:@"-" withString:@";"];
        }
    }
    
    [self finishPopViewEven];//返回前一控制器
}




/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = 50;
    titlesView.y = 0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = UIColorFromRGB(0x3ea5eb);
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x3ea5eb) forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            // 让按钮内部的label根据文字内容来计算尺寸
            //            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
    
    //底部分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,49.5 , ScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xDBDDE1);
    [titlesView addSubview:line];
}

- (void)titleClick:(UIButton *)button
{
    //没有选择省，不能点击省
    if([button.titleLabel.text isEqualToString:@"城市"] && !self.provinceInfo.length){
        return;
    }
    //没有选择市，不能点击地区
    if([button.titleLabel.text isEqualToString:@"地区"] && !self.cityInfo.length){
        return;
    }
    
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.05 animations:^{
        self.indicatorView.width = button.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    CGFloat Y = self.titlesView.height+self.titlesView.y;
    contentView.frame = CGRectMake(0,Y,ScreenWidth,ScreenHeight-Y-NavigationBarHeight-BottomHeight);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    //    contentView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    self.contentView.scrollEnabled = NO;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.curentIndex = index;
    
    // 取出子控制器
    PlacePickChildController *vc = self.childViewControllers[index];
    self.title = vc.title;
    
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    if (vc.type == PlaceVcTypeProvince) {
        vc.dataArray = self.provinceArr;
        vc.selectedInfo = self.provinceInfo;
    }else if (vc.type == PlaceVcTypeCity){
        vc.dataArray = self.cityArr;
        vc.selectedInfo = self.cityInfo;
    }else if (vc.type == PlaceVcTypeCounty){
        vc.dataArray = self.countryArr;
        vc.selectedInfo = self.countryInfo;
    }else{
        vc.dataArray = self.commonUseArr;
    }

    [vc.collectionView reloadData];
    
    if (vc.view.superview) return;//2017-7-13
    [scrollView addSubview:vc.view];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.curentIndex = index;
    [self titleClick:self.titlesView.subviews[index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)commonUseArr{
    if (_commonUseArr == nil) {
        _commonUseArr = [NSMutableArray array];
    }
    return _commonUseArr;
}
-(NSMutableArray *)provinceArr{
    if (_provinceArr == nil) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}
-(NSMutableArray *)cityArr{
    if (_cityArr == nil) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}
-(NSMutableArray *)countryArr{
    if (_countryArr == nil) {
        _countryArr = [NSMutableArray array];
    }
    return _countryArr;
}



@end



