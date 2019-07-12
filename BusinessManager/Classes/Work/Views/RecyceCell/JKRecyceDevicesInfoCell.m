//
//  JKRecyceDevicesInfoCell.m
//  BusinessManager
//
//  Created by  on 2018/10/17.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDevicesInfoCell.h"
#import "JKRecyceModel.h"

@interface JKRecyceDevicesInfoCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *addBtn;
@end

@implementation JKRecyceDevicesInfoCell

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
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setFishPondList:(NSMutableArray *)fishPondList {
    _fishPondList = fishPondList;
//    for (NSDictionary *dict in _fishPondList) {
//        JKRecyceModel *model = [[JKRecyceModel alloc] init];
//        model.maintainKeeper = dict[@"maintainKeeper"];
//        model.maintainKeeperID = dict[@"maintainKeeperID"];
//        model.name = dict[@"name"];
//        model.pondId = dict[@"pondId"];
//        model.pondAddress = dict[@"pondAddress"];
//        NSArray *arr = dict[@"childDeviceList"];
//        for (NSDictionary *dic in arr) {
//            model.ident = dic[@"identifier"];
//            model.type = dic[@"type"];
//        }
//        [self.dataSource addObject:model];
//    }
    [self.tableView reloadData];
}

- (void)clickAddBtn:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(addBtnClick:)]) {
        [_delegate addBtnClick:btn];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fishPondList.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == self.fishPondList.count + 1) {
        return 1;
    } else {
        NSDictionary *dict = self.fishPondList[section - 1];
        NSArray *arr = dict[@"childDeviceList"];
        return arr.count + 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = kBgColor;
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == self.fishPondList.count) {
        return 0;
    } else if (section == self.fishPondList.count + 1) {
        return 0;
    } else {
       return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.textLabel.text = @"设备清单";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(16);
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [addBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        addBtn.tag = indexPath.section;
        [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = JKFont(16);
        [cell.contentView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView).offset(-15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        return cell;
    } else if (indexPath.section == self.fishPondList.count + 1) {
        static NSString *ID = @"celll";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger rowCount = 0;
        for (NSDictionary * dict in self.fishPondList) {
            NSArray *arr = dict[@"childDeviceList"];
            rowCount += arr.count;
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"拆机套数：%ld套", rowCount];
        cell.detailTextLabel.textColor = RGBHex(0x333333);
        cell.detailTextLabel.font = JKFont(16);
        
        return cell;
    } else {
        NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        NSDictionary *dict = self.fishPondList[indexPath.section - 1];
        NSArray *arr = dict[@"childDeviceList"];
        if (indexPath.row == 0) {
            UILabel *nameLb = [[UILabel alloc] init];
            nameLb.text = dict[@"name"];
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
            addrLb.text = dict[@"pondAddress"];
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
            
        } else if (indexPath.row == arr.count + 1) {
            cell.textLabel.text = @"运维管家";
            cell.textLabel.textColor = RGBHex(0x333333);
            cell.textLabel.font = JKFont(14);
            
            cell.detailTextLabel.text = dict[@"maintainKeeper"];
            cell.detailTextLabel.textColor = RGBHex(0x888888);
            cell.detailTextLabel.font = JKFont(14);
        } else {
            for (NSDictionary *dic in dict[@"childDeviceList"]) {
                cell.textLabel.text = dic[@"type"];
                cell.textLabel.textColor = RGBHex(0x333333);
                cell.textLabel.font = JKFont(14);
                
                cell.detailTextLabel.text = dic[@"identifier"];
                cell.detailTextLabel.textColor = RGBHex(0x888888);
                cell.detailTextLabel.font = JKFont(14);
            }
        }
        
        return cell;
    }
}

#pragma mark -- 取消粘性效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 10;
        CGFloat sectionFooterHeight = 10;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight) {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        } else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight) {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        } else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height) {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}

@end
