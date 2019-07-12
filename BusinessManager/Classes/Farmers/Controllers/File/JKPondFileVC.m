//
//  JKPondFileVC.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKPondFileVC.h"
#import "JKPondModel.h"
@interface JKPondFileVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *valueArr;
@end

@implementation JKPondFileVC
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"鱼塘信息";
    
    NSLog(@"%@",self.model.pondId);
    
    self.titleArr = @[@"鱼塘名称", @"鱼塘面积", @"鱼种", @"鱼塘设备", @"鱼塘地址", @"投放鱼苗时间", @"预计卖鱼时间"];
    NSString *fishVariety;
    if ([[NSString stringWithFormat:@"%@",self.model.fishVariety] isEqualToString:@"<null>"]) {
        fishVariety = @"";
    } else {
        fishVariety = [NSString stringWithFormat:@"%@",self.model.fishVariety];
    }
    NSString *putInDate;
    if ([[NSString stringWithFormat:@"%@",self.model.putInDate] isEqualToString:@"<null>"]) {
        putInDate = @"";
    } else {
        putInDate = [NSString stringWithFormat:@"%@",self.model.putInDate];
    }
    
    
    for (NSDictionary *dic in self.model.childDeviceList) {
        self.valueArr = @[self.model.name, [NSString stringWithFormat:@"%@亩",self.model.area], fishVariety, dic[@"name"], self.model.pondAddress, putInDate, [NSString stringWithFormat:@"%@",self.model.reckonSaleDate]];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self dropDownRefresh];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 刷新接口
- (void)refreshData {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALE_SIZE(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(15);
    cell.detailTextLabel.text = self.valueArr[indexPath.row];
    cell.detailTextLabel.textColor = RGBHex(0x999999);
    cell.detailTextLabel.font = JKFont(15);
    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

@end
