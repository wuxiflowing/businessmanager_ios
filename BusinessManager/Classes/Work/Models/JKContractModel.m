//
//  JKContractModel.m
//  BusinessManager
//
//  Created by  on 2018/6/28.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractModel.h"

@implementation JKContractModel

- (NSMutableArray *)contractImgArr {
    if (!_contractImgArr) {
        _contractImgArr = [[NSMutableArray alloc] init];
    }
    return _contractImgArr;
}

- (NSMutableArray *)payImgArr {
    if (!_payImgArr) {
        _payImgArr = [[NSMutableArray alloc] init];
    }
    return _payImgArr;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (NSMutableArray<ContractDeviceList *> *)contractDeviceList {
    if (!_contractDeviceList) {
        _contractDeviceList = [[NSMutableArray alloc] init];
    }
    return _contractDeviceList;
}


@end

@implementation ContractDeviceList

@end
