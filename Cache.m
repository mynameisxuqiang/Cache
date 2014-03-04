//
//  Cache.m
//  HGBMall
//
//  Created by xuqiang on 14-2-24.
//  Copyright (c) 2014年 xuqiang. All rights reserved.
//

#import "Cache.h"
//超时时间 5分钟
#define TIME_OUT 60 * 5
@implementation Cache

//生成路径
+(NSString*)cachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cachePath = [cachePath stringByAppendingPathComponent:@"DataCache"];
     NSFileManager *fm =[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:cachePath isDirectory:nil]) {
        BOOL result = [fm createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result) {
            NSLog(@"--创建DataCache目录成功");
        }
        else{
            NSLog(@"--创建DataCache目录失败");
        }
    }
    return cachePath;
}

//写缓存数据
+(BOOL)cacheForDictionary:(NSString *)str name:(NSString *)fileName
{
    
    NSString *fileName1 = [ZRMD5 md5:fileName Parameters:@"a"];
    NSString *cachePath = [[Cache cachePath] stringByAppendingPathComponent:fileName1];
    NSFileManager *manager = [NSFileManager defaultManager];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [manager changeCurrentDirectoryPath:[Cache cachePath]];
    });
    
    [manager createFileAtPath:fileName contents:nil attributes:nil];
    NSDate *date = [NSDate date];
   NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [formatter stringFromDate:date];
    //字典中存放的内容有 当前(写入时间)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:dateString  forKey:@"date"];
    [dict setObject:str forKey:@"content"];
//    NSLog(@"写入内容%@",dict);
//    NSLog(@"写入路径%@",cachePath);
    return [self writeToFile:cachePath dictionary:dict];
    
}

+(BOOL)writeToFile:(NSString*)path dictionary:(NSDictionary *)dict{
    
    NSString *jsonStr = [dict JSONRepresentation];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [data writeToFile:path atomically:YES];
    
}
//读缓存数据
+ (NSDictionary *)cacheForDictionaryWithName:(NSString *)name
{
    NSString *name1 = [ZRMD5 md5:name Parameters:@"a"];
    NSString * cachePath = [[Cache cachePath] stringByAppendingPathComponent:name1];
    NSDictionary *dict = [NSDictionary dictionary];
    dict  = [self readCacheDataWithPath:cachePath];
    return dict;
}
//读取数据方法
+ (NSDictionary *)readCacheDataWithPath:(NSString *)path
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager changeCurrentDirectoryPath:path];
    NSDictionary *fileAttributes = [manager attributesOfItemAtPath:path error:nil];
    NSDate *creatDate = [fileAttributes objectForKey:NSFileCreationDate];
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = TIME_OUT;
    NSTimeInterval timInterval1 = [date timeIntervalSinceDate:creatDate];
    if (timeInterval >= timInterval1) {
        //加入一个等待线程中
       __block NSData *data = [NSData data];
        dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, t, ^{
            data = [manager contentsAtPath:path];
            [data retain];
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        return  [[data autorelease] objectFromJSONData];
    }
    else{
        return nil;
    }
}
@end
