//
//  JKOpenAccountOrderCell.m
//  BusinessManager
//
//  Created by  on 2018/6/28.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOpenAccountOrderCell.h"
#import "JKContractModel.h"
#import "TZImagePickerHelper.h"
#import "JKInstallationMidView.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKOpenAccountOrderCell () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, JKInstallationMidViewDelegate>
{
    NSInteger _chooseSingleType;
    BOOL _chooseSinglePay;
    BOOL _chooseSinglePaymentMethod;
    CGFloat _deviceListRowHeight;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIButton *prepaymentBtn;
@property (nonatomic, strong) UIButton *serviceFeeBtn;
@property (nonatomic, strong) UIButton *depositBtn;
@property (nonatomic, strong) UIButton *unpaidBtn;
@property (nonatomic, strong) UIButton *paidBtn;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, strong) UIButton *remitBtn;
@property (nonatomic, strong) TZImagePickerHelper *contractHelper;
@property (nonatomic, strong) TZImagePickerHelper *payHelper;
@property (nonatomic, strong) NSMutableArray *imageContractURL;
@property (nonatomic, strong) NSMutableArray *imagePayURL;
@property (nonatomic, strong) UILabel *contractLb;
@property (nonatomic, strong) UILabel *payLb;
@property (nonatomic, strong) UIScrollView *contractScrollView;
@property (nonatomic, strong) UIScrollView *payScrollView;
@property (nonatomic, strong) JKInstallationMidView *midView;
@property (nonatomic, strong) NSMutableArray *deviceList;

@end


@implementation JKOpenAccountOrderCell

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

- (NSMutableArray *)imageContractURL {
    if (!_imageContractURL) {
        _imageContractURL = [NSMutableArray array];
    }
    return _imageContractURL;
}

- (NSMutableArray *)imagePayURL {
    if (!_imagePayURL) {
        _imagePayURL = [NSMutableArray array];
    }
    return _imagePayURL;
}

- (NSMutableArray *)imageContractArr {
    if (!_imageContractArr) {
        _imageContractArr = [NSMutableArray array];
    }
    return _imageContractArr;
}

- (NSMutableArray *)imagePayArr {
    if (!_imagePayArr) {
        _imagePayArr = [NSMutableArray array];
    }
    return _imagePayArr;
}

- (NSMutableArray *)deviceList {
    if (!_deviceList) {
        _deviceList = [NSMutableArray array];
    }
    return _deviceList;
}

- (TZImagePickerHelper *)contractHelper {
    if (!_contractHelper) {
        _contractHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _contractHelper.imageType = JKImageTypeContract;
        _contractHelper.finishContract = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageContractURL addObjectsFromArray:array];
            JKContractModel *model = weakSelf.contractInfoArr[weakSelf.tag - 1];
            for (NSString *str in imageArr) {
                [weakSelf.imageContractArr addObject:str];
                [model.contractImgArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _contractHelper;
}

- (TZImagePickerHelper *)payHelper {
    if (!_payHelper) {
        _payHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _payHelper.imageType = JKImageTypePay;
        _payHelper.finishPay = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imagePayURL addObjectsFromArray:array];
            JKContractModel *model = weakSelf.contractInfoArr[weakSelf.tag - 1];
            for (NSString *str in imageArr) {
                [weakSelf.imagePayArr addObject:str];
                [model.payImgArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _payHelper;
}

- (NSMutableArray *)selectDeviceArr {
    if (!_selectDeviceArr) {
        _selectDeviceArr = [[NSMutableArray alloc] init];
    }
    return _selectDeviceArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        _chooseSingleType= 1;
        _chooseSinglePay = NO;
        _chooseSinglePaymentMethod = NO;
        
        self.titleArr = @[@"签约单", @"合同类型", @"签约日期", @"合同名称", @"合同金额", @"", @"养殖户是否付款", @"支付方式", @"实收金额", @"", @""];
        self.height = 584;
        self.contractTypeStr = @"押金合同";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSignData:)name:@"reloadSignData" object:nil];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        
        [self getDeviceList];
    }
    return self;
}

#pragma mark -- 获取设备
- (void)getDeviceList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/list/install",kUrl_Base];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if (responseObject[@"success"]) {
            self.deviceList =responseObject[@"data"];
        }
        _deviceListRowHeight = (self.deviceList.count + 2) * 48;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    } withFailureBlock:^(NSError *error) {
    }];
}

- (void)createUIWithModel:(JKContractModel *)model {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contractAmountTF.text = [NSString stringWithFormat:@"%@",model.contractAmountStr];
        self.actualAmountTF.text = [NSString stringWithFormat:@"%@",model.actualAmountStr];
        self.contractDateStr = model.contractDateStr;
        if (self.contractDateStr != nil) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    });
}

- (void)setContractInfoArr:(NSMutableArray *)contractInfoArr {
    _contractInfoArr = contractInfoArr;
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    JKContractModel *model = self.contractInfoArr[self.tag - 1];
    if (textField.tag == 4) {
        model.contractAmountStr = textField.text;
    } else if (textField.tag == 8) {
        model.actualAmountStr = textField.text;
    }
}

- (void)reloadSignData:(NSNotification *)noti {
    self.farmerNameStr = noti.userInfo[@"farmerName"];
    NSInteger tag = [noti.userInfo[@"tag"] integerValue];
    
    JKContractModel *model = self.contractInfoArr[tag - 1];
    self.contractDateStr = model.contractDateStr;
    self.contractNameDateStr = [self.contractDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.contractNameStr = [NSString stringWithFormat:@"%@%@%@",self.farmerNameStr,self.contractTypeStr,self.contractNameDateStr];
    model.contractName = self.contractNameStr;
    
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 单选
#pragma mark -- 合同类型
- (void)singleTypeSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 1) {
            self.prepaymentBtn.selected = NO;
            self.serviceFeeBtn.selected = NO;
            self.contractTypeStr = @"押金合同";
        } else if (btn.tag == 2) {
            self.depositBtn.selected = NO;
            self.prepaymentBtn.selected = NO;
            self.contractTypeStr = @"服务费合同";
        } else {
            self.depositBtn.selected = NO;
            self.serviceFeeBtn.selected = NO;
            self.contractTypeStr = @"预付款合同";
        }
        _chooseSingleType = btn.tag;
    }
    
    JKContractModel *model = self.contractInfoArr[self.tag - 1];
    model.contractType = self.contractTypeStr;
    if (self.farmerNameStr == nil || self.contractNameDateStr == nil) {
        return;
    }
    self.contractNameStr = [NSString stringWithFormat:@"%@%@%@",self.farmerNameStr,self.contractTypeStr,self.contractNameDateStr];
    model.contractName = self.contractNameStr;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 养殖户是否付款
- (void)singlePaySelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.paidBtn.selected = NO;
        } else {
            self.unpaidBtn.selected = NO;
        }
        _chooseSinglePay = !_chooseSinglePay;
    }
    
    if (!_chooseSinglePay) {
        JKContractModel *model = self.contractInfoArr[self.tag - 1];
        model.paymentMethod = @"";
        model.actualAmountStr = @"0";
    } else {
        JKContractModel *model = self.contractInfoArr[self.tag - 1];
        model.paymentMethod = @"现金";
    }
    
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:7 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:8 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark -- 支付方式
- (void)singlePaymentMethodSelected:(UIButton *)btn {
    if (_chooseSinglePay) {
        if (!btn.selected) {
            btn.selected = !btn.selected;
            if (btn.tag == 0) {
                self.remitBtn.selected = NO;
            } else {
                self.cashBtn.selected = NO;
            }
            _chooseSinglePaymentMethod = !_chooseSinglePaymentMethod;
        }
        NSLog(@"%d",_chooseSinglePaymentMethod);
        
        JKContractModel *model = self.contractInfoArr[self.tag - 1];
        if (_chooseSinglePaymentMethod) {
            model.paymentMethod = @"银行汇款";
        } else {
            model.paymentMethod = @"现金";
        }
    }
}

- (void)getSelectArray:(NSMutableArray *)selectedArr {
    if (selectedArr.count == 0) {
        return;
    }
    
    JKContractModel *model = self.contractInfoArr[self.tag - 1];
    [model.contractDeviceList removeAllObjects];
    
    for (NSString *str in selectedArr) {
        NSArray *deviceArr = [str componentsSeparatedByString:@"+"];
        ContractDeviceList *cModel = [[ContractDeviceList alloc] init];
        cModel.contractDeviceTypeId = deviceArr[0];
        cModel.contractDeviceNum = deviceArr[1];
        cModel.contractDeviceType = deviceArr[2];
        if (![cModel.contractDeviceNum isEqualToString:@"0"]) {
            [model.contractDeviceList addObject:cModel];
            NSLog(@"%@",model.contractDeviceList);
        }
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9 || indexPath.row == 10) {
        return 140;
    } else if (indexPath.row == 5) {
        if (_deviceListRowHeight > 0) {
            return _deviceListRowHeight;
        } else {
            return 144;
        }
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
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"删除"];
        cell.detailTextLabel.textColor = kRedColor;
    } else if (indexPath.row == 1) {
        UIButton *prepaymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [prepaymentBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [prepaymentBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [prepaymentBtn setTitle:@"  预付款" forState:UIControlStateNormal];
        [prepaymentBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [prepaymentBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        prepaymentBtn.titleLabel.font = JKFont(14);
        prepaymentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        prepaymentBtn.tag = 3;
        prepaymentBtn.selected = NO;
        [prepaymentBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:prepaymentBtn];
        [prepaymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        self.prepaymentBtn = prepaymentBtn;
        
        UIButton *serviceFeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceFeeBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [serviceFeeBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [serviceFeeBtn setTitle:@"  服务费" forState:UIControlStateNormal];
        [serviceFeeBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [serviceFeeBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        serviceFeeBtn.titleLabel.font = JKFont(14);
        serviceFeeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        serviceFeeBtn.tag = 2;
        serviceFeeBtn.selected = NO;
        [serviceFeeBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:serviceFeeBtn];
        [serviceFeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(prepaymentBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        self.serviceFeeBtn = serviceFeeBtn;
        
        UIButton *depositBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [depositBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [depositBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [depositBtn setTitle:@"  押金" forState:UIControlStateNormal];
        [depositBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [depositBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        depositBtn.titleLabel.font = JKFont(14);
        depositBtn.tag = 1;
        depositBtn.selected = YES;
        [depositBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:depositBtn];
        [depositBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(serviceFeeBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.depositBtn = depositBtn;
        
    } else if (indexPath.row == 2) {
        if (self.contractDateStr == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.contractDateStr;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 3) {
        if (self.contractNameStr == nil) {
            cell.detailTextLabel.text = @"养殖户名称+类型+时间";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.contractNameStr;
        }
    } else if (indexPath.row == 4 || indexPath.row == 8) {
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @"金额";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell);
            make.right.equalTo(cell).offset(-15);
            make.left.equalTo(cell.textLabel.mas_right).offset(20);
        }];
        
        if (indexPath.row == 4) {
            self.contractAmountTF = textField;
        } else if (indexPath.row == 8) {
            [self.actualAmountTF removeFromSuperview];
            self.actualAmountTF = textField;
            if (_chooseSinglePay) {
                self.actualAmountTF.enabled = YES;
            } else {
                self.actualAmountTF.text = @"";
                self.actualAmountTF.enabled = NO;
            }
        }
    } else if (indexPath.row == 5) {
        JKInstallationMidView *midView = [[JKInstallationMidView alloc] initWithFromSigningContractVC:YES];
        midView.delegate = self;
        [cell addSubview:midView];
        [midView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.right.equalTo(cell);
            make.height.mas_equalTo(_deviceListRowHeight);
        }];
        self.midView = midView;
    } else if (indexPath.row == 6) {
        UIButton *paidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [paidBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [paidBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [paidBtn setTitle:@"  已付" forState:UIControlStateNormal];
        [paidBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [paidBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        paidBtn.titleLabel.font = JKFont(14);
        paidBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        paidBtn.tag = 1;
        paidBtn.selected = NO;
        [paidBtn addTarget:self action:@selector(singlePaySelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:paidBtn];
        [paidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.paidBtn = paidBtn;
        
        UIButton *unpaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [unpaidBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [unpaidBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [unpaidBtn setTitle:@"  未付" forState:UIControlStateNormal];
        [unpaidBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [unpaidBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        unpaidBtn.titleLabel.font = JKFont(14);
        unpaidBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        unpaidBtn.tag = 0;
        unpaidBtn.selected = YES;
        [unpaidBtn addTarget:self action:@selector(singlePaySelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:unpaidBtn];
        [unpaidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(paidBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.unpaidBtn = unpaidBtn;
        
    } else if (indexPath.row == 7) {
        [self.remitBtn removeFromSuperview];
        UIButton *remitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [remitBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [remitBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [remitBtn setTitle:@"  银行汇款" forState:UIControlStateNormal];
        [remitBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [remitBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        remitBtn.titleLabel.font = JKFont(14);
        remitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (_chooseSinglePay) {
            remitBtn.tag = 1;
            remitBtn.selected = NO;
        } else {
            remitBtn.tag = 1;
            remitBtn.selected = NO;
        }
        [remitBtn addTarget:self action:@selector(singlePaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:remitBtn];
        [remitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        self.remitBtn = remitBtn;
        
        [self.cashBtn removeFromSuperview];
        UIButton *cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cashBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [cashBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [cashBtn setTitle:@"  现金" forState:UIControlStateNormal];
        [cashBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [cashBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        cashBtn.titleLabel.font = JKFont(14);
        cashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (_chooseSinglePay) {
            cashBtn.tag = 0;
            cashBtn.selected = YES;
        } else {
            cashBtn.tag = 0;
            cashBtn.selected = NO;
        }
        [cashBtn addTarget:self action:@selector(singlePaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cashBtn];
        [cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(remitBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.cashBtn = cashBtn;
    } else if (indexPath.row == 9 || indexPath.row == 10) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.font = JKFont(14);
        [cell addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(48);
        }];
        
        if (indexPath.row == 9) {
            [self.contractLb removeFromSuperview];
            [self.contractScrollView removeFromSuperview];
            titleLb.text = @"上传合同";
            self.contractLb = titleLb;
            [self createScrollImageUI:titleLb withCell:cell withImageType:JKImageTypeContract withImageArr:self.imageContractURL];
        } else if (indexPath.row == 10) {
            [self.payLb removeFromSuperview];
            [self.payScrollView removeFromSuperview];
            titleLb.text = @"上传付款凭证";
            self.payLb = titleLb;
            [self createScrollImageUI:titleLb withCell:cell withImageType:JKImageTypePay withImageArr:self.imagePayURL];
        }
    }
    
    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    if (imageType == JKImageTypeContract) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.contractScrollView = scrollView;
        
        if (imgArr.count == 0) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, 80, 80);
            addBtn.tag = imageType;
            [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addBtn];
        } else {
            if (imgArr.count == 9) {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showContractImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 10;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                }
            } else {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showContractImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 10;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    
                    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                    addBtn.tag = imageType;
                    [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:addBtn];
                }
            }
        }
    } else if (imageType == JKImageTypePay) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.payScrollView = scrollView;
        
        if (imgArr.count == 0) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, 80, 80);
            addBtn.tag = imageType;
            [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addBtn];
        } else {
            if (imgArr.count == 9) {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showPayImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 20;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                }
            } else {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showPayImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 20;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    
                    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                    addBtn.tag = imageType;
                    [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:addBtn];
                }
            }
        }
    }
}

- (void)showContractImgVClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageContractURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showPayImgVClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imagePayURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == JKImageTypeContract) {
        [self.contractHelper showImagePickerControllerWithMaxCount:(9 - self.imageContractArr.count) WithViewController:[self View:self]];
    } else if (btn.tag == JKImageTypePay) {
        [self.payHelper showImagePickerControllerWithMaxCount:(9 - self.imagePayArr.count) WithViewController:[self View:self]];
    }
}

- (void)deleteBtnClick:(UIButton *)btn {
    if (btn.tag <= 19) {
        [self.imageContractURL removeObjectAtIndex:(btn.tag - 10)];
        [self.imageContractArr removeObjectAtIndex:(btn.tag - 10)];
        JKContractModel *model = self.contractInfoArr[self.tag - 1];
        [model.contractImgArr removeObjectAtIndex:(btn.tag - 10)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if (btn.tag <= 29) {
        [self.imagePayURL removeObjectAtIndex:(btn.tag - 20)];
        [self.imagePayArr removeObjectAtIndex:(btn.tag - 20)];
        JKContractModel *model = self.contractInfoArr[self.tag - 1];
        [model.payImgArr removeObjectAtIndex:(btn.tag - 20)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -- view对应的UIViewController
- (UIViewController *)View:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([_delegate respondsToSelector:@selector(deleteOrderWithNumber:)]) {
            [_delegate deleteOrderWithNumber:self.tag];
        }
    } else if (indexPath.row == 2) {
        if ([_delegate respondsToSelector:@selector(alertContractTimeWithCellTag:)]) {
            [_delegate alertContractTimeWithCellTag:self.tag];
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
