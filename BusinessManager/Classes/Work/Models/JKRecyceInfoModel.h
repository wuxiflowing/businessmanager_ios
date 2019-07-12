//
//  JKRecyceInfoModel.h
//  BusinessManager
//
//  Created by  on 2018/10/31.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
@class JKPondInfoModel;
@interface JKRecyceInfoModel : NSObject
@property (nonatomic, strong) NSString *txtPondName;
@property (nonatomic, strong) NSString *txtPondPhone;
@property (nonatomic, strong) NSString *txtPondID;
@property (nonatomic, strong) NSString *txtPondAddr;
@property (nonatomic, strong) NSString *txtFarmerName;
@property (nonatomic, strong) NSString *txtFarmerAddr;
@property (nonatomic, strong) NSString *txtHKID;
@property (nonatomic, strong) NSString *txtHKPhone;
@property (nonatomic, strong) NSString *txtFarmerPhone;
@property (nonatomic, strong) NSString *txtFormNo;
@property (nonatomic, strong) NSString *txtFarmerID;
@property (nonatomic, strong) NSString *txtMatnerMembNo;
@property (nonatomic, strong) NSString *txtMatnerMembName;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *txtResMulti;
@property (nonatomic, strong) NSString *tarRemarks;
@property (nonatomic, strong) NSArray *tarEqps;
@property (nonatomic, strong) NSArray <JKPondInfoModel *>*tabPonds;
@property (nonatomic, strong) NSArray *brokenUrls;
@property (nonatomic, strong) NSArray *recycleUrls;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, assign) BOOL isGood;
@property (nonatomic, strong) NSString *explain;
@property (nonatomic, strong) NSString *txtDamageImgSrc;
@property (nonatomic, strong) NSString *txtFormImgSrc;
@property (nonatomic, strong) NSString *tarExplain;


@property (nonatomic, strong) NSString *txtStartDate;
@property (nonatomic, strong) NSString *txtCenMagName;
@property (nonatomic, strong) NSString *txtHK;
@property (nonatomic, strong) NSString *tarCustomerReson;

@property (nonatomic, strong) NSString *txtCSMembName;
@property (nonatomic, strong) NSString *tarReson;

@property (nonatomic, assign) BOOL rdoYes;

@end

@interface JKPondInfoModel : NSObject
@property (nonatomic, strong) NSString *ITEM1;
@property (nonatomic, strong) NSString *ITEM2;
@property (nonatomic, strong) NSString *ITEM3;
@property (nonatomic, strong) NSString *ITEM4;
@property (nonatomic, strong) NSString *ITEM6;

@end
