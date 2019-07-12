//
//  NSString+JKString.h
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JKString)

- (NSString *)trimmingCharacters;

- (NSString *)pinyin;

- (NSString *)cacheDic;

@end
