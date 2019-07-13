//
//  Typedef.h
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#ifndef Typedef_h
#define Typedef_h

typedef NS_ENUM(NSInteger, JKOrderInfo) {
    JKOrderInfoService,
    JKOrderInfoDeposit,
    JKOrderInfoPrepayment,
    JKOrderInfoFeed,
};

typedef NS_ENUM(NSInteger, JKSuccess) {
    JKSuccessOpenAccount,
    JKSuccessContract,
    JKSuccessInstallOrder,
};

typedef NS_ENUM(NSInteger, JKInstallation) {
    JKInstallationWait,
    JKInstallationIng,
    JKInstallationEd,
};

typedef NS_ENUM(NSInteger, JKRepaire) {
    JKRepaireWait,
    JKRepaireIng,
    JKRepaireEd,
};

typedef NS_ENUM(NSInteger, JKRecyce) {
    JKRecyceCheck,
    JKRecycePending,
    JKRecyceOverrule,
    JKRecyceThrough,
    JKRecyceFinish,
    JKRecyceAuditPass,
    JKRecyceAuditReject,
    JKRecyceMagAuditPass,
    JKRecyceMagAuditReject,
    JKRecyceWait,
    JKRecyceIng,
    JKRecyceEd,
};

typedef NS_ENUM(NSInteger, JKMaintain) {
    JKMaintainWait,
    JKMaintainIng,
    JKMaintainEd,
};

typedef NS_ENUM(NSInteger, JKModify) {
    JKModifyNickName,
    JKModifyMangerArea,
    JKModifyMangerLevel,
};

typedef NS_ENUM(NSInteger, JKImageType) {
    JKImageTypeIDFront,
    JKImageTypeIDBackground,
    JKImageTypeAccount,
    JKImageTypeFarmer,
    JKImageTypePond,
    JKImageTypeRepaire,
    JKImageTypeContract,
    JKImageTypePay,
    JKImageTypeRecyceAnnex,
    JKImageTypeInstallOrder,
    JKImageTypeInstallService,
    JKImageTypeInstallDeposit,
    JKImageTypeRepaireFixOrder,
    JKImageTypeRepaireReceipt,
    JKImageTypeMaintain,
    JKImageTypeAttachFile,
};

typedef NS_ENUM(NSInteger, JKContractType) {
    JKContractTypeSign,
    JKContractTypeInstallation,
    JKContractTypeRepaire,
    JKContractTypeRecyce,
    JKContractTypeDeposit,
    JKContractTypeService,
};

typedef NS_ENUM(NSInteger, JKEquipmentType) {
    JKEquipmentType_Old,
    JKEquipmentType_New,
};
#endif /* Typedef_h */
