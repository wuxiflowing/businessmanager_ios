//
//  JKFarmerModel.m
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFarmerModel.h"
#import "NSString+JKString.h"

@implementation JKFarmerModel

- (void)setFarmerName:(NSString<Optional> *)farmerName {
    if (farmerName) {
        _farmerName = farmerName;
        if ([_farmerName hasPrefix:@"沈"]) {
            _pinyin = [@"s" stringByAppendingString:[_farmerName.pinyin substringFromIndex:1]];
        } else if ([_farmerName isEqualToString:@"ＬＳＦ"]) {
            _pinyin = [@"l" stringByAppendingString:[_farmerName.pinyin substringFromIndex:1]];
        } else {
            _pinyin = _farmerName.pinyin;
            _pinyin = [_pinyin lowercaseString];
        }
    }
}

- (instancetype)initWithDic:(NSDictionary *)dict{
    NSError *error = nil;
    self =  [self initWithDictionary:dict error:&error];
    return self;
}

@end
