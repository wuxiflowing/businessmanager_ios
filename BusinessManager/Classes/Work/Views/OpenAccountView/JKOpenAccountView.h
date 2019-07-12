//
//  JKOpenAccountView.h
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKOpenAccountViewDelegate <NSObject>
- (void)chooseRegions;
- (void)chooseBirthday;
//- (void)checkPhoneNumber:(NSString *)phoneNumber;
//- (void)checkIdCard:(NSString *)idCard;
@end

@interface JKOpenAccountView : UIView
@property (nonatomic, weak) id<JKOpenAccountViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageFrontArr;
@property (nonatomic, strong) NSMutableArray *imageBackgroundArr;
@property (nonatomic, strong) NSMutableArray *imageAccountArr;
@property (nonatomic, strong) NSMutableArray *imageFarmerArr;
@property (nonatomic, strong) NSMutableArray *imagePondArr;
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
@property (nonatomic, strong) NSString *townIdStr;
@property (nonatomic, strong) NSString *farmerIdStr;

@end
