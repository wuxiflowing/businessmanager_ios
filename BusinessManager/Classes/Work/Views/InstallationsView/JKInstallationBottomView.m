//
//  JKInstallationBottomView.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallationBottomView.h"

@interface JKInstallationBottomView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isDeposit;
    BOOL _isService;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *depositStr;
@property (nonatomic, strong) NSString *serviceStr;
@property (nonatomic, strong) UISwitch *depositSwitch;
@property (nonatomic, strong) UISwitch *serverSwitch;
@property (nonatomic, strong) UILabel *depositTitle;
@property (nonatomic, strong) UILabel *serverTitle;
@property (nonatomic, strong) UILabel *depositValueLb;
@property (nonatomic, strong) UILabel *serverValueLb;
@property (nonatomic, strong) UITextField *serverTF;
@property (nonatomic, strong) UITextField *depositTF;
@end

@implementation JKInstallationBottomView

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
        
        self.titleArr = @[@"安装信息", @"*安装地址", @"*运维管家", @"*预计安装时间", @"押金费用", @"服务费"];
//        self.depositSumStr = @"0";
//        self.serviceSumStr = @"0";
        _isDeposit = NO;
        _isService = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOperationPeopleCell:)name:@"reloadOperationPeopleCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInstallTimeCell:)name:@"reloadInstallTimeCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocationCell:)name:@"reloadLocationCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFree:)name:@"reloadFree" object:nil];
        
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark -- 押金
- (void)depositSwitchTouch:(UISwitch *)sender {
    if (sender.on) {
        _isDeposit = YES;
//        self.depositSumStr = self.depositStr;
    } else {
        _isDeposit = NO;
        self.depositSumStr = @"0";
    }
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 服务
- (void)serverSwitchTouch:(UISwitch *)sender {
    if (sender.on) {
        _isService = YES;
//        self.serviceSumStr = self.serviceStr;
    } else {
        _isService = NO;
        self.serviceSumStr = @"0";
    }
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 4) {
        self.depositSumStr = textField.text;
    } else if (textField.tag == 5) {
        self.serviceSumStr = textField.text;
    }
}

- (void)reloadOperationPeopleCell:(NSNotification *)noti {
    self.operationPeopleStr = noti.userInfo[@"memName"];
    self.memIdStr = noti.userInfo[@"memId"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadInstallTimeCell:(NSNotification *)noti {
    self.installTimeStr = noti.userInfo[@"date"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadFree:(NSNotification *)noti {
    self.depositStr = noti.userInfo[@"depositSum"];
    self.serviceStr = noti.userInfo[@"serviceSum"];
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -- 定位
- (void)addrBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(locationAddr)]) {
        [_delegate locationAddr];
    }
}

- (void)reloadLocationCell:(NSNotification *)noti {
    self.addrStr = noti.userInfo[@"addr"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
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
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        
        UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addrBtn setImage:[UIImage imageNamed:@"ic_installation_record_addr"] forState:UIControlStateNormal];
        [addrBtn addTarget:self action:@selector(addrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addrBtn];
        [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(12, 15));
        }];
        
        [self.addrTF removeFromSuperview];
        UITextField *addrTF = [[UITextField alloc] init];
        if (self.addrStr != nil) {
            addrTF.text = self.addrStr;
        } else {
            addrTF.placeholder = @"安装地址";
        }
        addrTF.textColor = RGBHex(0x333333);
        addrTF.font = JKFont(14);
        addrTF.textAlignment = NSTextAlignmentRight;
        addrTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        addrTF.enabled = NO;
        [cell addSubview:addrTF];
        [addrTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(addrBtn.mas_right).offset(-20);
            make.left.equalTo(cell.textLabel.mas_right).offset(10);
            make.height.mas_equalTo(30);
        }];
        self.addrTF = addrTF;
        
    } else if (indexPath.row == 2) {
        if (self.operationPeopleStr == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.operationPeopleStr;
        }
    } else if (indexPath.row == 3) {
        if (self.installTimeStr == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.installTimeStr;
        }
    } else if (indexPath.row == 4) {
        
        [self.depositSwitch removeFromSuperview];
        [self.depositTitle removeFromSuperview];
        [self.depositValueLb removeFromSuperview];
        
        UISwitch *depositSwitch = [[UISwitch alloc] init];
        depositSwitch.transform = CGAffineTransformMakeScale( 0.8, 0.8);
        [depositSwitch setOn:_isDeposit];
        [depositSwitch addTarget:self action:@selector(depositSwitchTouch:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:depositSwitch];
        [depositSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell).mas_offset(-SCALE_SIZE(15));
        }];
        self.depositSwitch = depositSwitch;
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"费用代收";
        title.textColor = RGBHex(0x888888);
        title.textAlignment = NSTextAlignmentRight;
        title.font = JKFont(13);
        [cell addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell);
            make.right.equalTo(depositSwitch.mas_left).offset(-5);
            make.width.mas_equalTo(70);
        }];
        self.depositTitle = title;
        
//        UILabel *depositValueLb = [[UILabel alloc] init];
//        if (self.depositStr != nil) {
//            depositValueLb.text = [NSString stringWithFormat:@"(￥%@)",self.depositStr];
//        } else {
//            depositValueLb.text = @"(￥0)";
//        }
//        depositValueLb.textColor = RGBHex(0x999999);
//        depositValueLb.textAlignment = NSTextAlignmentLeft;
//        depositValueLb.font = JKFont(13);
//        [cell addSubview:depositValueLb];
//        [depositValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell);
//            make.left.equalTo(cell.textLabel.mas_right);
//            make.right.equalTo(title.mas_left);
//        }];
//        self.depositValueLb = depositValueLb;
        
        if (_isDeposit) {
            UITextField *depositTF = [[UITextField alloc] init];
//            if (self.depositStr != nil) {
//                depositTF.text = self.depositStr;
//            } else {
//                depositTF.placeholder = @"请输入";
//            }
            depositTF.placeholder = @"请输入";
            depositTF.textColor = RGBHex(0x333333);
            depositTF.font = JKFont(14);
            depositTF.textAlignment = NSTextAlignmentLeft;
            depositTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            depositTF.enabled = YES;
            depositTF.keyboardType = UIKeyboardTypeDecimalPad;
            depositTF.tag = indexPath.row;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldDidChangeValue:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:depositTF];
            [cell addSubview:depositTF];
            [depositTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(title.mas_right).offset(-20);
                make.left.equalTo(cell.textLabel.mas_right).offset(10);
                make.height.mas_equalTo(30);
            }];
            self.depositTF = depositTF;
        } else {
            [self.depositTF removeFromSuperview];
            self.depositTF.text = @"";
            self.depositTF.enabled = NO;
            
        }
        
    } else if (indexPath.row == 5) {
        [self.serverSwitch removeFromSuperview];
        [self.serverTitle removeFromSuperview];
        [self.serverValueLb removeFromSuperview];
        
        UISwitch *serverSwitch = [[UISwitch alloc] init];
        serverSwitch.transform = CGAffineTransformMakeScale( 0.8, 0.8);
        [serverSwitch setOn:_isService];
        [serverSwitch addTarget:self action:@selector(serverSwitchTouch:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:serverSwitch];
        [serverSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell).mas_offset(-SCALE_SIZE(15));
        }];
        self.serverSwitch = serverSwitch;
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"费用代收";
        title.textColor = RGBHex(0x888888);
        title.textAlignment = NSTextAlignmentRight;
        title.font = JKFont(13);
        [cell addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell);
            make.right.equalTo(serverSwitch.mas_left).offset(-5);
            make.width.mas_equalTo(70);
        }];
        self.serverTitle = title;
        

        
//        UILabel *serverValueLb = [[UILabel alloc] init];
//        if (self.serviceStr != nil) {
//            serverValueLb.text = [NSString stringWithFormat:@"(￥%@)",self.serviceStr];
//        } else {
//            serverValueLb.text = @"(￥0)";
//        }
//        serverValueLb.textColor = RGBHex(0x999999);
//        serverValueLb.textAlignment = NSTextAlignmentLeft;
//        serverValueLb.font = JKFont(13);
//        [cell addSubview:serverValueLb];
//        [serverValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell);
//            make.left.equalTo(cell.textLabel.mas_right);
//            make.right.equalTo(title.mas_left);
//        }];
//        self.serverValueLb = serverValueLb;
        
        if (_isService) {
            UITextField *serverTF = [[UITextField alloc] init];
//            if (self.serviceStr != nil) {
//                serverTF.text = self.serviceStr;
//            } else {
//                serverTF.placeholder = @"请输入";
//            }
            serverTF.placeholder = @"请输入";
            serverTF.textColor = RGBHex(0x333333);
            serverTF.font = JKFont(14);
            serverTF.enabled = YES;
            serverTF.textAlignment = NSTextAlignmentLeft;
            serverTF.keyboardType = UIKeyboardTypeDecimalPad;
            serverTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            serverTF.tag = indexPath.row;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldDidChangeValue:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:serverTF];
            [cell addSubview:serverTF];
            [serverTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(title.mas_right).offset(-20);
                make.left.equalTo(cell.textLabel.mas_right).offset(10);
                make.height.mas_equalTo(30);
            }];
            self.serverTF = serverTF;
        } else {
            [self.serverTF removeFromSuperview];
            self.serverTF.text = @"";
            self.serverTF.enabled = NO;
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if ([_delegate respondsToSelector:@selector(chooseOperationPeoples)]) {
            [_delegate chooseOperationPeoples];
        }
    } else if (indexPath.row == 3) {
        if ([_delegate respondsToSelector:@selector(chooseInstallationTime)]) {
            [_delegate chooseInstallationTime];
        }
    } else if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(locationAddr)]) {
            [_delegate locationAddr];
        }
    }
}

@end
