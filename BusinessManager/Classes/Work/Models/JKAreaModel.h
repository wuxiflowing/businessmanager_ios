//
//  JKAreaModel.h
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKTownModel : NSObject
@property (nonatomic, strong) NSString *tName;
@property (nonatomic, strong) NSString *tId;
@end

@interface JKDistrictModel : NSObject
@property (nonatomic, strong) JKTownModel *tModel;
@property (nonatomic, strong) NSString *dName;
@property (nonatomic, strong) NSString *dId;

@end

@interface JKCityModel : NSObject
@property (nonatomic, strong) JKDistrictModel *dModel;
@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *cId;

@end

@interface JKProvinceModel : NSObject
@property (nonatomic, strong) JKCityModel *cModel;
@property (nonatomic, strong) NSString *pName;
@property (nonatomic, strong) NSString *pId;

@end

@interface JKAreaModel : NSObject
@property (nonatomic, strong) JKProvinceModel *pModel;

@end
