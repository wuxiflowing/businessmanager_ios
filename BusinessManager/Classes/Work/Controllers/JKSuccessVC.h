//
//  JKSuccessVC.h
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@interface JKSuccessVC : JKBaseVC
@property (nonatomic, assign) JKSuccess successType;
@property (nonatomic, assign) BOOL isGeneral;
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *farmerAdd;
@property (nonatomic, strong) NSString *farmerTel;
@property (nonatomic, strong) NSString *farmerPic;
@end
