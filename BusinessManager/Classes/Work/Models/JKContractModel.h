//
//  JKContractModel.h
//  BusinessManager
//
//  Created by  on 2018/6/28.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContractDeviceList;
@interface JKContractModel : NSObject
@property (nonatomic, strong) NSString *contractAmountStr;
@property (nonatomic, strong) NSString *actualAmountStr;
@property (nonatomic, strong) NSString *contractDateStr;
@property (nonatomic, strong) NSMutableArray <ContractDeviceList *> *contractDeviceList;

@property (nonatomic, strong) NSString *collectState;
@property (nonatomic, strong) NSString *contractAmount;
@property (nonatomic, strong) NSString *contractId;
@property (nonatomic, strong) NSString *contractImage;

@property (nonatomic, strong) NSString *contractName;
@property (nonatomic, strong) NSString *contractType;
@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSMutableArray *contractImgArr;
@property (nonatomic, strong) NSMutableArray *payImgArr;
@property (nonatomic, strong) NSMutableArray *imgArr;

@end

@interface ContractDeviceList : NSObject
@property (nonatomic, strong) NSString *contractDeviceNum;
@property (nonatomic, strong) NSString *contractDeviceType;
@property (nonatomic, strong) NSString *contractDeviceTypeId;
@end
