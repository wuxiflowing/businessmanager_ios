//
//  JKRecyceDevicePendInfoCell.m
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDevicePendInfoCell.h"

@interface JKRecyceDevicePendInfoCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation JKRecyceDevicePendInfoCell

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
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        self.titleArr = @[@"鱼塘信息", @"选择鱼塘", @"设备数量", @"鱼塘地址", @"鱼塘联系方式"];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
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
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(13);
    cell.detailTextLabel.font = JKFont(13);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(15);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"删除"];
        cell.detailTextLabel.textColor = kRedColor;
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"请选择";
        cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"请选择";
        cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = @"请填写";
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    } else if (indexPath.row == 4) {
        cell.detailTextLabel.text = @"请填写";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([_delegate respondsToSelector:@selector(deleteOrderWithNumber:)]) {
            [_delegate deleteOrderWithNumber:self.tag];
        }
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
