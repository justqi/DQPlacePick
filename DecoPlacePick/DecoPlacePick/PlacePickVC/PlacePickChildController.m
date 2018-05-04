//
//  PlacePickChildController.m
//  4PL
//
//  Created by 邓奇 on 2018/3/22.
//  Copyright © 2018年 广州增信信息科技有限公司. All rights reserved.
//

#import "PlacePickChildController.h"
#import "PlacePickCell.h"

@interface PlacePickChildController ()<UICollectionViewDelegate,UICollectionViewDataSource>



@end

@implementation PlacePickChildController

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"");
    self.collectionView.frame = CGRectMake(0, 0,self.view.width, self.view.height);
//    self.collectionView.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}


-(void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //    float kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    // cell的大小
    int cols = 3;
    CGFloat inset = 10;
    CGFloat width = (ScreenWidth-4*inset-1)/cols;
    CGFloat height = 40;
    flowLayout.itemSize = CGSizeMake(width,height);
    flowLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    // 设置每一行之间的间距
    flowLayout.minimumLineSpacing = inset;
    //同一行相邻两个cell的最小间距
    flowLayout.minimumInteritemSpacing = inset;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[PlacePickCell class] forCellWithReuseIdentifier:@"CollectionCell"];
//    self.collectionView.backgroundColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.view.backgroundColor = UIColorFromRGB(0xedeff4);
    self.collectionView.backgroundColor = UIColorFromRGB(0xedeff4);
}


#pragma mark UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlacePickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    NSString *dataStr = self.dataArray[indexPath.row];
    //字符串的分割 [重点]
    NSArray *array = [dataStr componentsSeparatedByString:@";"];//10;北京(省-市-区的格式都是;分割)
    
    NSString *provinceName = array[1];
    cell.titleStr = provinceName;
    
    if ([dataStr isEqualToString:self.selectedInfo]) {
        cell.backgroundColor = UIColorFromRGB(0x3ea5eb);
        [cell.titleLB setTintColor:[UIColor whiteColor]];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        [cell.titleLB setTintColor:UIColorFromRGB(0x333333)];
    }
//    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *dataStr = self.dataArray[indexPath.row];//10;北京
    self.selectedInfo = dataStr;
    if (self.BtnClickBlock) {
        self.BtnClickBlock(self.type,dataStr);
    }
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
