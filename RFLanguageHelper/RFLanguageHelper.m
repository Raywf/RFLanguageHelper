//
//  RFLanguageHelper.m
//  RFLanguageHelper
//
//  Created by Raywf on 2018/2/25.
//  Copyright © 2018年 S.Ray. All rights reserved.
//

#import "RFLanguageHelper.h"

@interface RFLanguageHelper ()
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSDictionary *appLanguage;
@property (nonatomic, assign) NSInteger languageCode;
@end

static NSString * const RFLanguageCode_Key = @"RFLanguageHelper_RFLanguageCode_Key";
static NSString * const RFLanguageString_Key = @"RFLanguageHelper_RFLanguageString_Key";
static RFLanguageHelper *instance = nil;
@implementation RFLanguageHelper

#pragma mark - Public Methods
+ (void)InitLanguageHelper:(NSString *)tableName {
    if (instance ||
        !(tableName && [tableName isKindOfClass:[NSString class]] && tableName.length>0)) {
        return;
    }

    [RFLanguageHelper SharedInstance].tableName = tableName;

    /**
     初始化语言选择字典 &
     [NSLocale preferredLanguages] // 手机系统首选语言列表
     [NSBundle mainBundle].localizations // App本地化语言列表
     [[NSBundle mainBundle].preferredLocalizations objectAtIndex:0] // 系统当前首选语言
     */
    NSMutableDictionary *appLanguage = [NSMutableDictionary dictionary];
    NSArray *localizations = [NSBundle mainBundle].localizations;
    NSString *sysLang = [[NSBundle mainBundle].preferredLocalizations objectAtIndex:0];
    for (NSInteger i = 0; i < localizations.count; i++) {
        [appLanguage setObject:localizations[i] forKey:@(i)];
        if ([sysLang isEqualToString:localizations[i]]) {
            [appLanguage setObject:sysLang forKey:@(-1)];
        }
    }
    if (![appLanguage.allKeys containsObject:@(-1)]) {
        [appLanguage setObject:localizations[0] forKey:@(-1)];
    }
    instance.appLanguage = [appLanguage copy];

    /**
     获取上一次的语言设置结果
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger oldLanguageCode = [[defaults objectForKey:RFLanguageCode_Key] integerValue];
    NSString *oldLanguageString = [defaults objectForKey:RFLanguageString_Key];
    if ((oldLanguageString && [oldLanguageString isKindOfClass:[NSString class]] && oldLanguageString.length>0)
        && [appLanguage.allKeys containsObject:@(oldLanguageCode)]) {
        instance.languageCode = oldLanguageCode;
    } else {
        instance.languageCode = -1;
        [defaults setObject:@(-1) forKey:RFLanguageCode_Key];
        [defaults setObject:[appLanguage objectForKey:@(-1)] forKey:RFLanguageString_Key];
        [defaults synchronize];
    }

    NSInteger languageCode = instance.languageCode;
    NSString *string = [appLanguage objectForKey:@(languageCode)];
    [self ResetBundle:string];
}

+ (NSDictionary *)AppLanguage {
    if (!instance) {
        NSLog(@"【RFLanguageHelper】未初始化！");
        return nil;
    }
    return [instance.appLanguage copy];
}

+ (NSInteger)LanguageCode {
    if (!instance) {
        NSLog(@"【RFLanguageHelper】未初始化！");
        return -1;
    }
    return instance.languageCode;
}

+ (void)SetAppLanguageViaCode:(NSInteger)code Completion:(void (^)(void))completion {
    if (!instance) {
        NSLog(@"【RFLanguageHelper】未初始化！");
        return;
    }

    if (![instance.appLanguage.allKeys containsObject:@(code)]) {
        NSLog(@"该语言类型码不存在！");
        return;
    }

    instance.languageCode = code;
    NSString *string = [instance.appLanguage objectForKey:@(code)];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(code) forKey:RFLanguageCode_Key];
    [defaults setObject:string forKey:RFLanguageString_Key];
    [defaults synchronize];

    [self ResetBundle:string];

    if (completion) {
        completion();
    }
}

+ (NSString *)GetStringByKey:(NSString *)key {
    if (!instance) {
        NSLog(@"【RFLanguageHelper】未初始化！");
        return key;
    }

    return [instance.bundle localizedStringForKey:key value:@"" table:instance.tableName];
}

#pragma mark - Private Methods
+ (RFLanguageHelper *)SharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RFLanguageHelper new];
    });
    return instance;
}

+ (void)ResetBundle:(NSString *)string {
    //NSString *path = [[NSBundle mainBundle] pathForResource:[self LanguageFormat:string]\
                                                     ofType:@"lproj"];
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    instance.bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)LanguageFormat:(NSString *)language {
    if ([language rangeOfString:@"zh-"].location == NSNotFound) {
        //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
        if ([language rangeOfString:@"-"].location != NSNotFound) {
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

@end
