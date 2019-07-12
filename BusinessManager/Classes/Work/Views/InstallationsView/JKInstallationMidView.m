//
//  JKInstallationMidView.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallationMidView.h"
#import "JKNumberBtnView.h"
#import "JKDeviceModel.h"
#import "JKContractModel.h"

@interface JKInstallationMidView () <UITableViewDelegate, UITableViewDataSource, JKNumberBtnViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *numberArr;
@property (nonatomic, strong) UIButton *deviceBtn;
@property (nonatomic, strong) JKNumberBtnView *nbV;
@end

@implementation JKInstallationMidView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

- (NSMutableArray *)numberArr {
    if (!_numberArr) {
        _numberArr = [[NSMutableArray alloc] init];
    }
    return _numberArr;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] init];
    }
    return _dataSource;
}

- (instancetype)initWithFromSigningContractVC:(BOOL)isFrom {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeviceCell:)name:@"reloadDeviceCell" object:nil];
        
        self.deviceCount = 0;
        
        if (isFrom) {
            [self getDeviceList];
        } else {
            CGFloat height = 48;
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadMidViewHeight" object:nil userInfo:@{@"height":[NSString stringWithFormat:@"%f",height]}]];
            [self addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)reloadDeviceCell:(NSNotification *)noti {
    NSArray *arr = noti.userInfo[@"contractDeviceList"];
    [self.dataSource removeAllObjects];
    for (NSDictionary *dict in arr) {
        JKDeviceModel *model = [[JKDeviceModel alloc] init];
        model.deviceTypeId = dict[@"contractDeviceID"];
        model.deviceTypeName = dict[@"contractDeviceType"];
        model.isSelected = NO;
        model.count = [dict[@"contractDeviceNum"] integerValue];
        [self.dataSource addObject:model];
//        [self getDeviceId:[self getDeviceId] withCount:[self getDeviceCount]];
    }
    
    CGFloat height = (self.dataSource.count + 2) * 48;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadMidViewHeight" object:nil userInfo:@{@"height":[NSString stringWithFormat:@"%f",height]}]];
    [self.tableView reloadData];
}

#pragma mark -- 获取设备
- (void)getDeviceList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/list/install",kUrl_Base];
    [YJProgressHUD showMessage:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKDeviceModel *model = [[JKDeviceModel alloc] init];
                model.deviceTypeId = dict[@"deviceTypeId"];
                model.deviceTypeName = dict[@"deviceTypeName"];
                model.isSelected = NO;
                model.count = 0;
                [self.dataSource addObject:model];
            }
        }
        
        CGFloat height = (self.dataSource.count + 2) * 48;
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadMidViewHeight" object:nil userInfo:@{@"height":[NSString stringWithFormat:@"%f",height]}]];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 多选
- (void)moreSelected:(UIButton *)btn {
    for (JKDeviceModel *model in self.dataSource) {
        NSLog(@"%d",model.isSelected);
    }
    
    
    btn.selected = !btn.selected;
    JKDeviceModel *model = self.dataSource[btn.tag - 1];
    model.isSelected = btn.selected ? YES : NO;
    

    
    [self getDeviceId:[self getDeviceId] withCount:[self getDeviceCount]];
}

#pragma mark -- JKNumberBtnViewDelegate
- (void)getCurrentNumber:(NSInteger)number withTag:(NSInteger)tag{
    JKDeviceModel *model = self.dataSource[tag - 1];
    model.count = number;
    
    [self getDeviceId:[self getDeviceId] withCount:[self getDeviceCount]];
}

- (void)getDeviceId:(NSString *)deviceId withCount:(NSInteger)count {
    self.deviceCount = count;
    
    [self.selectArray removeAllObjects];
    for (JKDeviceModel *model in self.dataSource) {
        NSString *count = [NSString stringWithFormat:@"%ld",model.count];
        NSString *deviceIdCount = [NSString stringWithFormat:@"%@+%@+%@",model.deviceTypeId,count,model.deviceTypeName];
        if (model.isSelected) {
            if (![self.selectArray containsObject:model.deviceTypeName]) {
                [self.selectArray addObject:deviceIdCount];
            }
        } else {
            if ([self.selectArray containsObject:deviceIdCount]) {
                [self.selectArray removeObject:deviceIdCount];
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(getSelectArray:)]) {
        [_delegate getSelectArray:self.selectArray];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataSource.count + 1) inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString *)getDeviceId {
    NSString *deviceId;
    for (JKDeviceModel *model in self.dataSource) {
        if (model.isSelected) {
            deviceId = model.deviceTypeId;
            if (model.count == 0) {
                model.count = 1;
            }
        }
    }
    return deviceId;
}

- (NSInteger)getDeviceCount {
    CGFloat count = 0;
    for (JKDeviceModel *model in self.dataSource) {
        if (model.isSelected) {
            count += model.count;
        }
    }
    return count;
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"设备清单";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == self.dataSource.count + 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"合计：%ld套",self.deviceCount];
        cell.detailTextLabel.textColor = RGBHex(0x333333);
        cell.detailTextLabel.font = JKFont(14);
    } else {
        if (self.dataSource.count != 0) {
            JKDeviceModel *model = self.dataSource[indexPath.row - 1];
            UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deviceBtn setImage:[UIImage imageNamed:@"ic_work_choose_off"] forState:UIControlStateNormal];
            [deviceBtn setImage:[UIImage imageNamed:@"ic_work_choose_on"] forState:UIControlStateSelected];
            [deviceBtn setTitle:[NSString stringWithFormat:@"  %@",model.deviceTypeName] forState:UIControlStateNormal];
            [deviceBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
            deviceBtn.titleLabel.font = JKFont(14);
            deviceBtn.tag = indexPath.row;
            deviceBtn.selected = NO;
            deviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
            [deviceBtn addTarget:self action:@selector(moreSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deviceBtn];
            [deviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.left.equalTo(cell.contentView.mas_left).offset(15);
                make.size.mas_equalTo(CGSizeMake(120, 30));
            }];
            self.deviceBtn = deviceBtn;
            
            JKNumberBtnView *nbV = [[JKNumberBtnView alloc] init];
            nbV.canEdit = NO;
            nbV.delegate = self;
            if (model.count != 0) {
                nbV.maxCount = model.count;
                nbV.currentCount = model.count;
            } else {
                nbV.minCount = 1;
                nbV.currentCount = 1;
            }
            nbV.tag = indexPath.row;
            [cell.contentView addSubview:nbV];
            [nbV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(deviceBtn.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(100, 30));
            }];
            self.nbV = nbV;
        }
    }
    return cell;
}

//#pragma mark -- cell的分割线顶头
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.layoutMargins = UIEdgeInsetsZero;
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.preservesSuperviewLayoutMargins = NO;
//}

@end
