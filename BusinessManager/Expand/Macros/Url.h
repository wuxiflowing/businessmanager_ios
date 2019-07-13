//
//  Url.h
//  BusinessManager
//
//  Created by  on 2018/7/30.
//  Copyright © 2018年 . All rights reserved.
//

#ifndef Url_h
#define Url_h

// 测试
#define kUrl_Base    @"http://apitest.celefish.com:8080"
#define API_KEY @"c02fa8abe880869d950267c17e51a564"
#define APP_KEY @"edf103568494ea87639ed23212c40dc7"

// 正式
//#define kUrl_Base    @"http://api.celefish.com:8080"
//#define API_KEY @"4521681f3976d526ff7ea73c0c48874a"
//#define APP_KEY @"5070babb366cd0e78b6985f5cfb3b4ca"

#define kGtAppId @"FNYJcyC5q8A070BwYhy7i3"
#define kGtAppKey @"Dq1k4xjV0x8IAxgWzQLo54"
#define kGtAppSecret @"WsFFOcNgfc98ftD9zZ7Fm3"











// 暂时不用
//#define kGtAppId @"PRhrys4Y1o6pNF0679g6YA"
//#define kGtAppKey @"VURP3cOFPA7YTSJOIwM7b8"
//#define kGtAppSecret @"ySYh0ZCqES7HOytDIElHi6"


#define kUrl_Login       [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/login"]
#define kUrl_Modify_Pwd   [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/updatePW"]
#define kUrl_Banner   [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/getBanner"]
#define kUrl_AppCSM      [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/createAppCSM"]

#endif /* Url_h */
