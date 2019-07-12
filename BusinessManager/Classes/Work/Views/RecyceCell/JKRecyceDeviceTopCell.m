//
//  JKRecyceDeviceTopCell.m
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDeviceTopCell.h"

@interface JKRecyceDeviceTopCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *pondCount;
@end

@implementation JKRecyceDeviceTopCell

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

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
        
        self.titleArr = @[@"基础信息", @"*选择养殖户", @"鱼塘数量", @"养殖户地址", @"联系方式"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecyceBaseInfo:)name:@"reloadRecyceBaseInfo" object:nil];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    
    }
    return self;
}

- (void)reloadRecyceBaseInfo:(NSNotification *)noti {
    self.addr = noti.userInfo[@"addr"];
    self.tel = noti.userInfo[@"contractInfo"];
    self.farmerName = noti.userInfo[@"farmerName"];
    self.farmerId = noti.userInfo[@"farmerId"];
    self.pondCount = noti.userInfo[@"pondCount"];
//    [self getCustomerInfo];
    [self.tableView reloadData];
}

//#pragma mark -- 用户基础信息
//- (void)getCustomerInfo {
//    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerData",kUrl_Base, self.farmerId];
//
//    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
//        [YJProgressHUD hide];
//        if (responseObject[@"success"]) {
//            self.pondCount = responseObject[@"data"][@"pondNumber"];
//        }
//        [self.tableView reloadData];
//    } withFailureBlock:^(NSError *error) {
//        [YJProgressHUD hide];
//    }];
//}

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
        if (self.farmerName != nil) {
            cell.detailTextLabel.text =self.farmerName;
        } else {
            cell.detailTextLabel.text = @"请选择养殖户";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        if (self.pondCount != nil) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.pondCount];
        } else {
            cell.detailTextLabel.text = @"数量";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        }
    } else if (indexPath.row == 3) {
        if (self.addr != nil) {
            cell.detailTextLabel.text = self.addr;
            cell.detailTextLabel.numberOfLines = 2;
        } else {
            cell.detailTextLabel.text = @"养殖户地址";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        }
    } else {
        if (self.tel != nil) {
            cell.detailTextLabel.text = self.tel;
        } else {
            cell.detailTextLabel.text = @"联系方式";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(chooseFarmers)]) {
            [_delegate chooseFarmers];
        }
    } else if (indexPath.row == 4) {
        
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


@end
