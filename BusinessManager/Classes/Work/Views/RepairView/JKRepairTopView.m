//
//  JKRepairTopView.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRepairTopView.h"

@interface JKRepairTopView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *tel;
@end


@implementation JKRepairTopView

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        self.titleArr = @[@"基础信息", @"*选择养殖户", @"养殖户地址", @"联系方式"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRepaireAddrAndTel:)name:@"reloadRepaireAddrAndTel" object:nil];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadRepaireAddrAndTel:(NSNotification *)noti {
    self.addr = noti.userInfo[@"addr"];
    self.tel = noti.userInfo[@"contractInfo"];
    self.farmerName = noti.userInfo[@"farmerName"];
    self.farmerId = noti.userInfo[@"farmerId"];
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
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
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if ([cell.textLabel.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [attString addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, 1)];
        cell.textLabel.attributedText = attString;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        if (self.tel == nil) {
            cell.detailTextLabel.text = @"请选择养殖户";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.farmerName;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        if (self.addr == nil) {
            cell.detailTextLabel.text = @"养殖户地址";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
            cell.detailTextLabel.numberOfLines = 2;
        } else {
            cell.detailTextLabel.text = self.addr;
        }
    } else if (indexPath.row == 3) {
        if (self.tel == nil) {
            cell.detailTextLabel.text = @"联系电话";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.tel;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(chooseFarmers)]) {
            [_delegate chooseFarmers];
        }
    } 
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
