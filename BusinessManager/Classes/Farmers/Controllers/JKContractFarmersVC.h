//
//  JKContractFarmersVC.h
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@protocol JKContractFarmersVCDelegate <NSObject>
- (void)popContractFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo withFarmerName:(NSString *)farmerName withFarmerId:(NSString *)farmerId;
- (void)popContractFarmerId:(NSString *)farmerId withFarmerName:(NSString *)farmerName withFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo;
@end

@interface JKContractFarmersVC : JKBaseVC
@property (nonatomic, weak) id<JKContractFarmersVCDelegate> delegate;
@property (nonatomic, assign) JKContractType contractType;
@end
