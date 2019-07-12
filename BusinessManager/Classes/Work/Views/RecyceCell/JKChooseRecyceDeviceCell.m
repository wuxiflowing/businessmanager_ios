//
//  JKChooseRecyceDeviceCell.m
//  BusinessManager
//
//  Created by  on 2018/10/16.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKChooseRecyceDeviceCell.h"
#import "JKPondModel.h"

@interface JKChooseRecyceDeviceCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JKPondModel *model;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pondAdress;
@property (nonatomic, strong) NSString *memId;
@property (nonatomic, strong) NSString *memName;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) UIButton *deviceBtn;
@end

@implementation JKChooseRecyceDeviceCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)sendPondModel:(JKPondModel *)pModel {
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    self.name = pModel.name;
    self.pondAdress = pModel.pondAddress;
    self.pondId = pModel.pondId;
    self.memId = pModel.maintainKeeperID;
    self.memName = pModel.maintainKeeper;
    
    [self.dataSource removeAllObjects];
    
    for (NSDictionary *dict in pModel.childDeviceList) {
        JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
        pcdModel.ident = dict[@"identifier"];
        pcdModel.deviceId = dict[@"id"];
        pcdModel.type = dict[@"type"];
        pcdModel.isSelected = [dict[@"isSelected"] boolValue];
        [self.dataSource addObject:pcdModel];
    }
    
    [self.tableView reloadData];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

#pragma mark -- 多选
- (void)moreSelected:(UIButton *)btn {
    btn.selected = !btn.selected;
    JKPondChildDeviceModel *pcdModel = self.dataSource[btn.tag];
    pcdModel.isSelected = !pcdModel.isSelected;
    
    if ([_delegate respondsToSelector:@selector(changeBtnState:withIndex:withSelected:)]) {
        [_delegate changeBtnState:btn.tag withIndex:self.index withSelected:pcdModel.isSelected];
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        UILabel *nameLb = [[UILabel alloc] init];
        nameLb.text = self.name;
        nameLb.textColor = RGBHex(0x333333);
        nameLb.textAlignment = NSTextAlignmentLeft;
        nameLb.font = JKFont(14);
        nameLb.numberOfLines = 2;
        [cell.contentView addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(15);
            make.width.mas_equalTo((SCREEN_WIDTH - 30) / 2);
        }];
        
        UILabel *addrLb = [[UILabel alloc] init];
        addrLb.text = self.pondAdress;
        addrLb.textColor = RGBHex(0x888888);
        addrLb.textAlignment = NSTextAlignmentLeft;
        addrLb.font = JKFont(14);
        addrLb.numberOfLines = 2;
        [cell.contentView addSubview:addrLb];
        [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(nameLb.mas_right);
            make.width.mas_equalTo((SCREEN_WIDTH - 30) / 2);
        }];
        
    } else if (indexPath.row == self.dataSource.count + 1) {
        cell.textLabel.text = @"运维管家";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(14);
        
        if ([self.memName isKindOfClass:[NSNull class]]) {
            cell.detailTextLabel.text = @"";
        } else {
            cell.detailTextLabel.text = self.memName;
        }
        cell.detailTextLabel.textColor = RGBHex(0x888888);
        cell.detailTextLabel.font = JKFont(14);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        JKPondChildDeviceModel *pcdModel = self.dataSource[indexPath.row - 1];
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setImage:[UIImage imageNamed:@"ic_work_choose_off"] forState:UIControlStateNormal];
        [deviceBtn setImage:[UIImage imageNamed:@"ic_work_choose_on"] forState:UIControlStateSelected];
        [deviceBtn setTitle:[NSString stringWithFormat:@"  %@ (%@)",pcdModel.type, pcdModel.ident] forState:UIControlStateNormal];
        [deviceBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        deviceBtn.titleLabel.font = JKFont(14);
        deviceBtn.tag = indexPath.row - 1;
        deviceBtn.selected = pcdModel.isSelected;
        deviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [deviceBtn addTarget:self action:@selector(moreSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deviceBtn];
        [deviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(30);
        }];
        
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count + 1) {
        if ([_delegate respondsToSelector:@selector(getMaintainKeeper:)]) {
            [_delegate getMaintainKeeper:self.index];
        }
    }
}

@end
