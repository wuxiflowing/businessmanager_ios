//
//  JKAdministrativeRegionsVC.h
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@protocol JKAdministrativeRegionsVCDelegate <NSObject>
- (void)popRegion:(NSString *)region withTownId:(NSString *)townIdStr;
@end

@interface JKAdministrativeRegionsVC : JKBaseVC
@property (nonatomic, weak) id<JKAdministrativeRegionsVCDelegate> delegate;
@end
