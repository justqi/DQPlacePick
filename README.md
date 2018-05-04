# DQPlacePick

```
-(void)btnClick:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
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
```

![image](https://github.com/justqi/DQPlacePick/blob/master/DecoPlacePick/code.png)

![image](https://github.com/justqi/DQPlacePick/blob/master/DecoPlacePick/选择省市区.gif)
