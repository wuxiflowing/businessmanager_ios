//
//  JKOpenAccountVC.h
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@interface JKOpenAccountVC : JKBaseVC
@property (nonatomic, strong) NSString *farmerIdStr;
@property (nonatomic, strong) NSString *farmerNameStr;
@property (nonatomic, strong) NSString *contactStr;
@property (nonatomic, strong) NSString *birthdayStr;
@property (nonatomic, strong) NSString *regionStr;
@property (nonatomic, strong) NSString *sexStr;
@property (nonatomic, strong) NSString *homeAddrStr;
@property (nonatomic, strong) NSString *idNumberStr;
@property (nonatomic, strong) NSString *idPicture;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *pondPicture;
@property (nonatomic, assign) BOOL isGeneral;
@end
