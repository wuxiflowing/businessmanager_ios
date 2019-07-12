//
//  JKRecyceDeviceCell.m
//  OperationsManager
//
//  Created by  on 2018/7/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDeviceCell.h"

@interface JKRecyceDeviceCell() <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isUnitied;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *untiedBtn;
@property (nonatomic, strong) UILabel *deviceIDLb;
@end

@implementation JKRecyceDeviceCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitiedState:)name:@"unitiedState" object:nil];
        
        _isUnitied = NO;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.right.bottom.equalTo(bgView);
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark -- 解绑设备
- (void)untiedBtnClick:(UIButton *)btn {
    if (!_isUnitied) {
        NSString *ident = self.dataSource[btn.tag - 1][@"ITEM2"];
        NSString *name = self.dataSource[btn.tag - 1][@"ITEM5"];
        if ([_delegate respondsToSelector:@selector(untiedDeviceWithIdent:withPondName:withIsSelected:)]) {
            [_delegate untiedDeviceWithIdent:ident withPondName:name withIsSelected:btn.selected];
        }
    }
}

- (void)unitiedState:(NSNotification *)noti {
    if (!_isUnitied) {
        self.untiedBtn.backgroundColor = kWhiteColor;
        self.untiedBtn.layer.borderColor = RGBHex(0xdddddd).CGColor;
        self.untiedBtn.layer.borderWidth = 1;
        self.untiedBtn.selected = YES;

        _isUnitied = YES;
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = JKFont(14);
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"设备清单";
        cell.textLabel.font = JKFont(16);
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row - 1][@"ITEM5"];
        cell.detailTextLabel.text = self.dataSource[indexPath.row - 1][@"ITEM2"];
    }
    
    return cell;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


@end
