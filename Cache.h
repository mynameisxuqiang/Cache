//
//  Cache.h
//  HGBMall
//
//  Created by xuqiang on 14-2-24.
//  Copyright (c) 2014年 xuqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ZRMD5.h"
@interface Cache : NSObject

+(NSString*)cachePath;

//存缓存数据
+(BOOL)cacheForDictionary:(NSString*)str name:(NSString *)fileName;

//+(BOOL)productCacheForDictionary:(NSDictionary*)dict;

//取缓存数据
+(NSDictionary *)cacheForDictionaryWithName:(NSString *)name;

@end
