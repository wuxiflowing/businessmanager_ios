//
//  JKInstallationTopView.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallationTopView.h"

@interface JKInstallationTopView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollServiceView;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSString *contractImage;
@property (nonatomic, strong) NSString *contractName;
@property (nonatomic, strong) NSArray *contractImageArr;
@property (nonatomic, strong) UILabel *contractTitleLb;

@property (nonatomic, strong) NSString *contractServiceImage;
@property (nonatomic, strong) NSString *contractServiceName;
@property (nonatomic, strong) NSArray *contractServiceImageArr;
@property (nonatomic, strong) UILabel *contractServiceTitleLb;
@property (nonatomic, strong) UIImageView *imgV1;
@property (nonatomic, strong) UIImageView *imgV2;
@end

@implementation JKInstallationTopView

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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

- (UIScrollView *)scrollServiceView {
    if (!_scrollServiceView) {
        _scrollServiceView = [[UIScrollView alloc] init];
        _scrollServiceView.showsHorizontalScrollIndicator = NO;
        _scrollServiceView.backgroundColor = kWhiteColor;
    }
    return _scrollServiceView;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.titleArr = @[@"基础信息", @"*选择养殖户", @"养殖户地址", @"联系方式", @"*选择押金合同", @"", @"查看服务合同", @""];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddrAndTel:)name:@"reloadAddrAndTel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContractCell:)name:@"reloadContractCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContractServiceCell:)name:@"reloadContractServiceCell" object:nil];
        
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadAddrAndTel:(NSNotification *)noti {
    self.addr = noti.userInfo[@"addr"];
    self.tel = noti.userInfo[@"contractInfo"];
    self.farmerName = noti.userInfo[@"farmerName"];
    self.farmerId = noti.userInfo[@"farmerId"];
    self.contractName = nil;
    self.contractImage = nil;
    self.contractImageArr = nil;
    self.contractServiceName = nil;
    self.contractServiceImage = nil;
    self.contractServiceImageArr = nil;
    [self.tableView reloadData];
}

- (void)reloadContractCell:(NSNotification *)noti {
    self.contractName = noti.userInfo[@"contractName"];
    self.contractImage = noti.userInfo[@"contractImage"];
    self.contractId = noti.userInfo[@"contractId"];
    self.contractImageArr = [self.contractImage componentsSeparatedByString:@","];
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadContractServiceCell:(NSNotification *)noti {
    self.contractServiceName = noti.userInfo[@"contractName"];
    self.contractServiceImage = noti.userInfo[@"contractImage"];
//    self.contractId = noti.userInfo[@"contractId"];
    self.contractServiceImageArr = [self.contractServiceImage componentsSeparatedByString:@","];
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:6 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:7 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5 || indexPath.row == 7) {
        return 110;
    } else {
        return 48;
    }
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
        cell.textLabel.textColor = RGBHex(0x333333);
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
    } else if (indexPath.row == 6) {
        if (self.contractServiceName == nil) {
            cell.detailTextLabel.text = @"合同名称";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.contractServiceName;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 7) {
        [self.contractServiceTitleLb removeFromSuperview];
        UILabel *contractTitleLb = [[UILabel alloc] init];
        contractTitleLb.text = @"合同附件";
        contractTitleLb.textColor = RGBHex(0x333333);
        contractTitleLb.textAlignment = NSTextAlignmentLeft;
        contractTitleLb.font = JKFont(14);
        [cell.contentView addSubview:contractTitleLb];
        [contractTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(100, 48));
        }];
        self.contractServiceTitleLb = contractTitleLb;
        
        [self.scrollServiceView removeFromSuperview];
        self.scrollServiceView = nil;
        [self.imgV2 removeFromSuperview];
        self.imgV2 = nil;
        if (self.contractServiceImageArr.count > 0) {
            [cell.contentView addSubview:self.scrollServiceView];
            [self.scrollServiceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contractTitleLb.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(50);
            }];
            
            self.scrollServiceView.contentSize = CGSizeMake(60 * self.contractServiceImageArr.count, 50);
            
            for (NSInteger i = 0; i < self.contractServiceImageArr.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(60 * i , 0, 50, 50);
                imgV.userInteractionEnabled = YES;
                NSString *img = self.contractServiceImageArr[i];
                imgV.yy_imageURL = [NSURL URLWithString:img];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollServiceView addSubview:imgV];
                self.imgV2 = imgV;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                [btn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        } else {
            [self.scrollServiceView removeFromSuperview];
        }
    } else if (indexPath.row == 4) {
        if (self.contractName == nil) {
            cell.detailTextLabel.text = @"合同名称";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.contractName;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 5) {
        [self.contractTitleLb removeFromSuperview];
        UILabel *contractTitleLb = [[UILabel alloc] init];
        contractTitleLb.text = @"合同附件";
        contractTitleLb.textColor = RGBHex(0x333333);
        contractTitleLb.textAlignment = NSTextAlignmentLeft;
        contractTitleLb.font = JKFont(14);
        [cell.contentView addSubview:contractTitleLb];
        [contractTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(100, 48));
        }];
        self.contractTitleLb = contractTitleLb;

        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        [self.imgV1 removeFromSuperview];
        self.imgV1 = nil;
        if (self.contractImageArr.count > 0) {
            [cell.contentView addSubview:self.scrollView];
            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contractTitleLb.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(50);
            }];
            
            self.scrollView.contentSize = CGSizeMake(60 * self.contractImageArr.count, 50);
            
            
            for (NSInteger i = 0; i < self.contractImageArr.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(60 * i , 0, 50, 50);
                imgV.userInteractionEnabled = YES;
                NSString *img = self.contractImageArr[i];
                imgV.yy_imageURL = [NSURL URLWithString:img];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:imgV];
                self.imgV1 = imgV;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        } else {
            [self.scrollView removeFromSuperview];
        }
        
    }
    return cell;
}

- (void)btnClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.contractImageArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)serviceBtnClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.contractServiceImageArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(chooseFarmers)]) {
            [_delegate chooseFarmers];
        }
    } else if (indexPath.row == 6) {
        if (self.farmerName == nil) {
            [YJProgressHUD showMessage:@"请选择养殖户" inView:self];
        } else {
            if ([_delegate respondsToSelector:@selector(chooseContractServices)]) {
                [_delegate chooseContractServices];
            }
        }
    } else if (indexPath.row == 4) {
        if (self.farmerName == nil) {
            [YJProgressHUD showMessage:@"请选择养殖户" inView:self];
        } else {
            if ([_delegate respondsToSelector:@selector(chooseContracts)]) {
                [_delegate chooseContracts];
            }
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
