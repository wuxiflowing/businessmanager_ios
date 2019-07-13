//
//  JKFarmerMainView.h
//  BusinessManager
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKPondModel;
@class JKPondChildDeviceModel;
@protocol JKFarmerMainViewDelegate <NSObject>
- (void)scrollNavigationBarWithTitle:(NSString *)title withIsClear:(BOOL)isClear;
- (void)clickFileBtn:(UIButton *)btn;
- (void)clickSignBtnWithFarmerId:(NSString *)farmerId withFarmerName:(NSString *)farmerName withContractInfo:(NSString *)contractInfo withBirthday:(NSString *)birthday withSex:(NSString *)sex withRegion:(NSString *)region withHomeAddress:(NSString *)homeAddress withIDNumber:(NSString *)idNumber withIdPicture:(NSString *)idPicture withPicture:(NSString *)picture withPondPicture:(NSString *)pondPicture;
- (void)pushPondsInfoVC:(JKPondModel *)model;
- (void)pushDevicesInfoVC:(JKPondChildDeviceModel *)dModel;
- (void)farmerAddr:(NSString *)addr;
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKFarmerMainView : UIView
@property (nonatomic, weak) id<JKFarmerMainViewDelegate> delegate;
@property (nonatomic, strong) NSString *customerIdStr;
@property (nonatomic, assign) BOOL isGeneral;
- (void)reloadTopViewInfo;

@end
