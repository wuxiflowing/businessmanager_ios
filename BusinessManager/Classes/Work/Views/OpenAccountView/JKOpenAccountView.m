//
//  JKOpenAccountView.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOpenAccountView.h"
#import "TZImagePickerHelper.h"
#import "UIButton+JKButton.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKOpenAccountView () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UITextFieldDelegate>
{
    BOOL _male;
}
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIButton *womanBtn;
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) TZImagePickerHelper *idFrontHelper;
@property (nonatomic, strong) TZImagePickerHelper *idBackgroundHelper;
@property (nonatomic, strong) TZImagePickerHelper *accountHelper;
@property (nonatomic, strong) TZImagePickerHelper *farmerHelper;
@property (nonatomic, strong) TZImagePickerHelper *pondHelper;
@property (nonatomic, strong) NSMutableArray *imageFrontURL;
@property (nonatomic, strong) NSMutableArray *imageBackgroundURL;
@property (nonatomic, strong) NSMutableArray *imageAccountURL;
@property (nonatomic, strong) NSMutableArray *imageFarmerURL;
@property (nonatomic, strong) NSMutableArray *imagePondURL;
@property (nonatomic, strong) UILabel *titleIDLb;
@property (nonatomic, strong) UIImageView *positiveImgV;
@property (nonatomic, strong) UIImageView *negativeImgV;
@property (nonatomic, strong) UILabel *positiveLb;
@property (nonatomic, strong) UILabel *negativeLb;
@property (nonatomic, strong) UILabel *accountLb;
@property (nonatomic, strong) UILabel *farmerLb;
@property (nonatomic, strong) UILabel *pondLb;
@property (nonatomic, strong) UIScrollView *accountScrollView;
@property (nonatomic, strong) UIScrollView *farmerScrollView;
@property (nonatomic, strong) UIScrollView *pondScrollView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *idCardTF;

@end

@implementation JKOpenAccountView

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

- (TZImagePickerHelper *)idFrontHelper {
    if (!_idFrontHelper) {
        _idFrontHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _idFrontHelper.imageType = JKImageTypeIDFront;
        _idFrontHelper.finishIDFront = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageFrontURL removeAllObjects];
            [weakSelf.imageFrontURL addObjectsFromArray:array];
            weakSelf.imageFrontArr = [imageArr mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _idFrontHelper;
}

- (TZImagePickerHelper *)idBackgroundHelper {
    if (!_idBackgroundHelper) {
        _idBackgroundHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _idBackgroundHelper.imageType = JKImageTypeIDBackground;
        _idBackgroundHelper.finishIDBackground = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageBackgroundURL removeAllObjects];
            [weakSelf.imageBackgroundURL addObjectsFromArray:array];
            weakSelf.imageBackgroundArr  = [imageArr mutableCopy];;
            dispatch_async(dispatch_get_main_queue(), ^{

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _idBackgroundHelper;
}

- (TZImagePickerHelper *)accountHelper {
    if (!_accountHelper) {
        _accountHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _accountHelper.imageType = JKImageTypeAccount;
        _accountHelper.finishAccount = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageAccountURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageAccountArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _accountHelper;
}

- (TZImagePickerHelper *)farmerHelper {
    if (!_farmerHelper) {
        _farmerHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _farmerHelper.imageType = JKImageTypeFarmer;
        _farmerHelper.finishFarmer = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageFarmerURL removeAllObjects];
            [weakSelf.imageFarmerArr removeAllObjects];
            [weakSelf.imageFarmerURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageFarmerArr addObject:str];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _farmerHelper;
}

- (TZImagePickerHelper *)pondHelper {
    if (!_pondHelper) {
        _pondHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _pondHelper.imageType = JKImageTypePond;
        _pondHelper.finishPond = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imagePondURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imagePondArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _pondHelper;
}

- (NSMutableArray *)imageFrontURL {
    if (!_imageFrontURL) {
        _imageFrontURL = [NSMutableArray array];
    }
    return _imageFrontURL;
}

- (NSMutableArray *)imageBackgroundURL {
    if (!_imageBackgroundURL) {
        _imageBackgroundURL = [NSMutableArray array];
    }
    return _imageBackgroundURL;
}

- (NSMutableArray *)imageAccountURL {
    if (!_imageAccountURL) {
        _imageAccountURL = [NSMutableArray array];
    }
    return _imageAccountURL;
}

- (NSMutableArray *)imageFarmerURL {
    if (!_imageFarmerURL) {
        _imageFarmerURL = [NSMutableArray array];
    }
    return _imageFarmerURL;
}

- (NSMutableArray *)imagePondURL {
    if (!_imagePondURL) {
        _imagePondURL = [NSMutableArray array];
    }
    return _imagePondURL;
}

- (NSMutableArray *)imageFrontArr {
    if (!_imageFrontArr) {
        _imageFrontArr = [NSMutableArray array];
    }
    return _imageFrontArr;
}

- (NSMutableArray *)imageBackgroundArr {
    if (!_imageBackgroundArr) {
        _imageBackgroundArr = [NSMutableArray array];
    }
    return _imageBackgroundArr;
}

- (NSMutableArray *)imageAccountArr {
    if (!_imageAccountArr) {
        _imageAccountArr = [NSMutableArray array];
    }
    return _imageAccountArr;
}

- (NSMutableArray *)imageFarmerArr {
    if (!_imageFarmerArr) {
        _imageFarmerArr = [NSMutableArray array];
    }
    return _imageFarmerArr;
}

- (NSMutableArray *)imagePondArr {
    if (!_imagePondArr) {
        _imagePondArr = [NSMutableArray array];
    }
    return _imagePondArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        
        self.titleArr = @[@"*养殖户姓名", @"*联系方式", @"*出生日期", @"*性别", @"*行政区域", @"*家庭详细地址", @"", @"", @"身份证号",@"", @""];
        
        _male = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBirthday:)name:@"reloadBirthday" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRegion:)name:@"reloadRegion" object:nil];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setPicture:(NSString *)picture {
    _picture = picture;
    if ([_picture isEqualToString:@""]) {
        return;
    }
    NSArray *pictureArr = [_picture componentsSeparatedByString:@","];
    if (pictureArr.count != 0) {
        for (NSString *pictureStr in pictureArr) {
            [self.imageFarmerURL addObject:pictureStr];
            [self.imageFarmerArr addObject:pictureStr];
        }
        [self.tableView reloadData];
    }
}

- (void)setPondPicture:(NSString *)pondPicture {
    _pondPicture = pondPicture;
    if ([_pondPicture isEqualToString:@""]) {
        return;
    }
    NSArray *pictureArr = [_pondPicture componentsSeparatedByString:@","];
    if (pictureArr.count != 0) {
        for (NSString *pictureStr in pictureArr) {
            [self.imagePondURL addObject:pictureStr];
            [self.imagePondArr addObject:pictureStr];
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 0) {
        self.farmerNameStr = textField.text;
    } else if (textField.tag == 1) {
        self.contactStr = textField.text;
    } else if (textField.tag == 5) {
        self.homeAddrStr = textField.text;
    } else if (textField.tag == 8) {
        self.idNumberStr = textField.text;
    }
}

#pragma mark -- 性别单选
- (void)maleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.womanBtn.selected = NO;
        } else {
            self.manBtn.selected = NO;
        }
        _male = !_male;
    }
    self.sexStr = !_male ? @"男" : @"女";
}

#pragma mark -- 出生日期
- (void)reloadBirthday:(NSNotification *)noti {
    self.birthdayStr = noti.userInfo[@"birthdayStr"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 行政区域
- (void)reloadRegion:(NSNotification *)noti {
    self.regionStr = noti.userInfo[@"regionStr"];
    self.townIdStr = noti.userInfo[@"townId"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 正面照
- (void)positiveBtnClick:(UIButton *)btn {
    [self.idFrontHelper showImagePickerControllerWithMaxCount:1 WithViewController:[self View:self]];
}

#pragma mark -- 反面照
- (void)negativeBtnClick:(UIButton *)btn {
    [self.idBackgroundHelper showImagePickerControllerWithMaxCount:1 WithViewController:[self View:self]];
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

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        return 185;
    } else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 10) {
        return 140;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
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
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 8) {
        UITextField *textField = [[UITextField alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-15);
            make.left.equalTo(cell.textLabel.mas_right).offset(20);
        }];
        
        if (indexPath.row == 0) {
            if (self.farmerNameStr != nil && ![self.farmerNameStr isKindOfClass:[NSNull class]]) {
                textField.text = self.farmerNameStr;
                textField.textColor = RGBHex(0x333333);
            } else {
                textField.placeholder = @"请输入姓名";
            }
            self.nameTF = textField;
        } else if (indexPath.row == 1) {
            if (self.contactStr != nil) {
                textField.text = self.contactStr;
                textField.textColor = RGBHex(0x333333);
            } else {
                textField.placeholder = @"请输入联系电话";
            }
            textField.keyboardType = UIKeyboardTypeNumberPad;
            self.phoneTF = textField;
        } else if (indexPath.row == 5) {
            if (self.homeAddrStr != nil && ![self.homeAddrStr isKindOfClass:[NSNull class]]) {
                textField.text = self.homeAddrStr;
                textField.textColor = RGBHex(0x333333);
            } else {
                textField.placeholder = @"请输入详细地址";
            }
            self.addressTF = textField;
        } else if (indexPath.row == 8) {
            if (![self.idNumberStr isKindOfClass:[NSNull class]]) {
                if (self.idNumberStr != nil && ![self.idNumberStr isEqualToString:@""]) {
                    textField.text = self.idNumberStr;
                    textField.textColor = RGBHex(0x333333);
                } else {
                    textField.placeholder = @"请输入身份证号码";
                }
            } else {
                textField.placeholder = @"请输入身份证号码";
            }
            self.idCardTF = textField;
        }
    } else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.birthdayStr != nil) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.birthdayStr];
            cell.detailTextLabel.textColor = RGBHex(0x666666);
        } else {
            cell.detailTextLabel.text = @"请选择出生日期";
            cell.detailTextLabel.textColor = RGBHex(0xcccccc);
        }
    } else if (indexPath.row == 3) {
        UIButton *womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [womanBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [womanBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [womanBtn setTitle:@"  女" forState:UIControlStateNormal];
        [womanBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [womanBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        womanBtn.titleLabel.font = JKFont(14);
        womanBtn.tag = 1;
        if (self.sexStr != nil) {
            if ([self.sexStr isEqualToString:@"男"]) {
                womanBtn.selected = NO;
            } else {
                womanBtn.selected = YES;
            }
        } else {
            womanBtn.selected = NO;
        }
        [womanBtn addTarget:self action:@selector(maleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:womanBtn];
        [womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.womanBtn = womanBtn;
        
        UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [manBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [manBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [manBtn setTitle:@"  男" forState:UIControlStateNormal];
        [manBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [manBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        manBtn.titleLabel.font = JKFont(14);
        manBtn.tag = 0;
        if (self.sexStr != nil) {
            if ([self.sexStr isEqualToString:@"男"]) {
                manBtn.selected = YES;
            } else {
                manBtn.selected = NO;
            }
        } else {
            manBtn.selected = YES;
        }
        [manBtn addTarget:self action:@selector(maleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:manBtn];
        [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(womanBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.manBtn = manBtn;
    } else if (indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.regionStr != nil && ![self.regionStr isKindOfClass:[NSNull class]]) {
            cell.detailTextLabel.text = self.regionStr;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
        } else {
            cell.detailTextLabel.text = @"请选择省市区镇";
            cell.detailTextLabel.textColor = RGBHex(0xcccccc);
        }
    } else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10) {
            UILabel *titleLb = [[UILabel alloc] init];
            titleLb.textColor = RGBHex(0x333333);
            titleLb.textAlignment = NSTextAlignmentLeft;
            titleLb.font = JKFont(14);
            [cell.contentView addSubview:titleLb];
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(15);
                make.right.equalTo(cell.contentView).offset(-15);
                make.height.mas_equalTo(48);
            }];
            
            if (indexPath.row == 9) {
                [self.titleIDLb removeFromSuperview];
                [self.positiveLb removeFromSuperview];
                [self.negativeLb removeFromSuperview];
                [self.positiveImgV removeFromSuperview];
                [self.negativeImgV removeFromSuperview];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:@"上传身份证"];
                [attString addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:NSMakeRange(0, 1)];
                titleLb.attributedText = attString;
                
                self.titleIDLb = titleLb;
                
                if (![self.idPicture isKindOfClass:[NSNull class]]) {
                    NSArray *idPictureArr = [self.idPicture componentsSeparatedByString:@","];
                    if (idPictureArr.count == 2) {
                        [self.imageFrontURL addObject:idPictureArr[0]];
                        [self.imageBackgroundURL addObject:idPictureArr[1]];
                        [self.imageFrontArr addObject:idPictureArr[0]];
                        [self.imageBackgroundArr addObject:idPictureArr[1]];
                    }
                }

                UIImageView *positiveImgV = [[UIImageView alloc] init];
                if (self.imageFrontURL.count == 0) {
                    positiveImgV.image = [UIImage imageNamed:@"ic_id_card"];
                } else {
                    if ([self.imageFrontURL[0] hasPrefix:@"http"]) {
                        positiveImgV.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageFrontURL[0]]];
                    } else {
                        positiveImgV.image = [UIImage imageWithContentsOfFile:self.imageFrontURL[0]];
                    }
                }
                positiveImgV.contentMode = UIViewContentModeScaleAspectFit;
                positiveImgV.userInteractionEnabled = YES;
                [cell.contentView addSubview:positiveImgV];
                [positiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLb.mas_bottom);
                    make.left.equalTo(cell.contentView).offset(15);
                    make.right.equalTo(cell.contentView.mas_centerX).offset(-7.5);
                    make.height.mas_equalTo(100);
                }];
                self.positiveImgV = positiveImgV;
                
                UILabel *positiveLb = [[UILabel alloc] init];
                positiveLb.text = @"正面照";
                positiveLb.textColor = RGBHex(0x333333);
                positiveLb.textAlignment = NSTextAlignmentCenter;
                positiveLb.font = JKFont(13);
                [cell.contentView addSubview:positiveLb];
                [positiveLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(positiveImgV.mas_bottom);
                    make.left.equalTo(positiveImgV.mas_left);
                    make.right.equalTo(positiveImgV.mas_right);
                    make.bottom.equalTo(cell.contentView.mas_bottom);
                }];
                self.positiveLb = positiveLb;
                
                UIButton *positiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [positiveBtn addTarget:self action:@selector(positiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [positiveImgV addSubview:positiveBtn];
                [positiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.equalTo(positiveImgV);
                }];
                
                UIImageView *negativeImgV = [[UIImageView alloc] init];
                if (self.imageBackgroundURL.count == 0) {
                    negativeImgV.image = [UIImage imageNamed:@"ic_id_card"];
                } else {
                    NSLog(@"%@",self.imageBackgroundURL[0]);
                    if ([self.imageBackgroundURL[0] hasPrefix:@"http"]) {
                        negativeImgV.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageBackgroundURL[0]]];
                    } else {
                        negativeImgV.image = [UIImage imageWithContentsOfFile:self.imageBackgroundURL[0]];
                    }
                }
                negativeImgV.contentMode = UIViewContentModeScaleAspectFit;
                negativeImgV.userInteractionEnabled = YES;
                [cell.contentView addSubview:negativeImgV];
                [negativeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLb.mas_bottom);
                    make.right.equalTo(cell.contentView).offset(-15);
                    make.left.equalTo(cell.contentView.mas_centerX).offset(7.5);
                    make.height.mas_equalTo(100);
                }];
                self.negativeImgV = negativeImgV;
                
                UILabel *negativeLb = [[UILabel alloc] init];
                negativeLb.text = @"反面照";
                negativeLb.textColor = RGBHex(0x333333);
                negativeLb.textAlignment = NSTextAlignmentCenter;
                negativeLb.font = JKFont(13);
                [cell.contentView addSubview:negativeLb];
                [negativeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(negativeImgV.mas_bottom);
                    make.left.equalTo(negativeImgV.mas_left);
                    make.right.equalTo(negativeImgV.mas_right);
                    make.bottom.equalTo(cell.contentView.mas_bottom);
                }];
                self.negativeLb = negativeLb;
                
                UIButton *negativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [negativeBtn addTarget:self action:@selector(negativeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [negativeImgV addSubview:negativeBtn];
                [negativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.equalTo(negativeImgV);
                }];
                
            } else if (indexPath.row == 6) {
                [self.farmerLb removeFromSuperview];
                [self.farmerScrollView removeFromSuperview];
                titleLb.text = @"上传养殖户照片";
                self.farmerLb = titleLb;
                [self createScrollImageUI:titleLb withCell:cell withImageType:JKImageTypeFarmer withImageArr:self.imageFarmerURL];
            } else if (indexPath.row == 7) {
                [self.pondLb removeFromSuperview];
                [self.pondScrollView removeFromSuperview];
                titleLb.text = @"上传鱼塘照片";
                self.pondLb = titleLb;
                [self createScrollImageUI:titleLb withCell:cell withImageType:JKImageTypePond withImageArr:self.imagePondURL];
            } else if (indexPath.row == 10) {
                [self.accountLb removeFromSuperview];
                [self.accountScrollView removeFromSuperview];
                titleLb.text = @"上传登记表(签约必传)";
                self.accountLb = titleLb;
                [self createScrollImageUI:titleLb withCell:cell withImageType:JKImageTypeAccount withImageArr:self.imageAccountURL];
            }
        }

    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    if (imageType == JKImageTypeAccount) {
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
        self.accountScrollView = scrollView;
        
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
                    [btn addTarget:self action:@selector(showAccountImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i;
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
                    [btn addTarget:self action:@selector(showAccountImgVClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i;
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
    } else if (imageType == JKImageTypeFarmer) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell.contentView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.contentView.mas_left).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.farmerScrollView = scrollView;
        
        if (imgArr.count == 0) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, 80, 80);
            addBtn.tag = imageType;
            [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addBtn];
        } else {
            if (imgArr.count == 1) {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = imageType;
                    if ([imgArr[i] hasPrefix:@"http"]) {
                        [btn jk_setButtonImageWithUrl:[NSString stringWithFormat:@"%@",imgArr[i]]];
                    } else {
                        [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    }
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                }
            }
//            else {
//                for (NSInteger i = 0; i < imgArr.count; i++) {
//                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
//                    btn.tag = i;
//                    if ([imgArr[i] hasPrefix:@"http"]) {
//                        [btn jk_setButtonImageWithUrl:[NSString stringWithFormat:@"%@",imgArr[i]]];
//                    } else {
//                        [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
//                    }
//                    [btn addTarget:self action:@selector(showFarmerImgVClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [scrollView addSubview:btn];
//
//                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
//                    deleteBtn.tag = i + 10;
//                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
//                    [btn addSubview:deleteBtn];
//                }
//
//                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                addBtn.frame = CGRectMake(90 * imgArr.count, 0, 80, 80);
//                addBtn.tag = imageType;
//                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
//                [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [scrollView addSubview:addBtn];
//            }
        }
    } else if (imageType == JKImageTypePond) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell.contentView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.contentView.mas_left).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.pondScrollView = scrollView;
        
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
                    btn.frame = CGRectMake(90 * i, 0, 80, 80);
                    btn.tag = i;
                    if ([imgArr[i] hasPrefix:@"http"]) {
                        [btn jk_setButtonImageWithUrl:[NSString stringWithFormat:@"%@",imgArr[i]]];
                    } else {
                        [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    }
                    [btn addTarget:self action:@selector(showPondImgVClick:) forControlEvents:UIControlEventTouchUpInside];
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
                    btn.frame = CGRectMake(90 * i, 0, 80, 80);
                    btn.tag = i;
                    if ([imgArr[i] hasPrefix:@"http"]) {
                        [btn jk_setButtonImageWithUrl:[NSString stringWithFormat:@"%@",imgArr[i]]];
                    } else {
                        [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    }
                    [btn addTarget:self action:@selector(showPondImgVClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == JKImageTypeAccount) {
        [self.accountHelper showImagePickerControllerWithMaxCount:(9 - self.imageAccountArr.count) WithViewController:[self View:self]];
    } else if (btn.tag == JKImageTypeFarmer) {
        [self.farmerHelper showImagePickerControllerWithMaxCount:1 WithViewController:[self View:self]];
    } else if (btn.tag == JKImageTypePond) {
        [self.pondHelper showImagePickerControllerWithMaxCount:(9 - self.imagePondArr.count) WithViewController:[self View:self]];
    }
}

#pragma mark -- 显示鱼塘照片
- (void)showPondImgVClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imagePondURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

#pragma mark -- 显示养殖户照片
- (void)showFarmerImgVClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageFarmerURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

#pragma mark -- 显示登记表照片
- (void)showAccountImgVClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageAccountURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)deleteBtnClick:(UIButton *)btn {
    if (btn.tag <= 9) {
        [self.imageAccountURL removeObjectAtIndex:btn.tag];
        [self.imageAccountArr removeObjectAtIndex:btn.tag];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if (btn.tag <= 19) {
        
        [self.imageFarmerURL removeObjectAtIndex:(btn.tag - 10)];
        [self.imageFarmerArr removeObjectAtIndex:(btn.tag - 10)];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if (btn.tag <= 29) {
        [self.imagePondURL removeObjectAtIndex:(btn.tag - 20)];
        [self.imagePondArr removeObjectAtIndex:(btn.tag - 20)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if ([_delegate respondsToSelector:@selector(chooseBirthday)]) {
            [_delegate chooseBirthday];
        }
    } else if (indexPath.row == 4) {
        if ([_delegate respondsToSelector:@selector(chooseRegions)]) {
            [_delegate chooseRegions];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    if ([string containsString:@"\n"]) {
        return NO;
    }
    
    if (textField == self.phoneTF) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    if (textField == self.idCardTF) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
    }
    
    return YES;
}

@end
