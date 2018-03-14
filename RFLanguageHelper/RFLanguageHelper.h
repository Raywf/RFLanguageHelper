//
//  RFLanguageHelper.h
//  RFLanguageHelper
//
//  Created by Raywf on 2018/2/25.
//  Copyright © 2018年 S.Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RFLanguage(key) [RFLanguageHelper GetStringByKey:key]

@interface RFLanguageHelper : NSObject

/**
 初始化
 @param tableName 多语言本地支持文件
 */
+ (void)InitLanguageHelper:(NSString *)tableName;

/**
 获取当前设置的语言信息字典
 */
+ (NSDictionary *)AppLanguage;

/**
 获取当前设置的语言类型码
 */
+ (NSInteger)LanguageCode;

/**
 设置应用显示语言
 @param code 语言类型码
 @param completion 设置完成后可执行的Block
 */
+ (void)SetAppLanguageViaCode:(NSInteger)code Completion:(void (^)(void))completion;

/**
 根据key来显示当前选择好的语言
 @param key 关键词
 @return 根据当前已选择的语言版本显示语言
 */
+ (NSString *)GetStringByKey:(NSString *)key;

@end
