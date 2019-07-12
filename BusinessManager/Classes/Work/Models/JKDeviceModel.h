//
//  JKDeviceModel.h
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKDeviceModel : NSObject
@property (nonatomic, strong) NSString *deviceTypeId;
@property (nonatomic, strong) NSString *deviceTypeName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *deviceCount;
@end
