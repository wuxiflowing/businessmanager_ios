//
//  JKFarmerModel.h
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKFarmerModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*farmerAdd;
@property (nonatomic, strong) NSString <Optional>*farmerRegion;
@property (nonatomic, strong) NSString <Optional>*farmerId;
@property (nonatomic, strong) NSString <Optional>*farmerName;
@property (nonatomic, strong) NSString <Optional>*farmerTel;
@property (nonatomic, strong) NSString <Optional>*farmerPic;
@property (nonatomic, strong) NSString <Ignore>*pinyin;

- (instancetype)initWithDic:(NSDictionary *)dict;
@end
