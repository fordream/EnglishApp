//
//  IFlySpeechUtility.h
//  MSCDemo
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFlySpeechError;

/*!
 *  用户配置
 */
@class IFlySpeechUtility;

@interface IFlySpeechUtility : NSObject

/*!
 *  创建用户语音配置
 *      注册应用请前往语音云开发者网站。<br>
 *  网站：http://open.voicecloud.cn/developer.php
 *
 *  @param params 启动参数，必须保证appid参数传入，示例：appid=123456
 *
 *  @return 语音配置对象
 */
+ (IFlySpeechUtility*) createUtility:(NSString *) params;

/*!
 *  销毁用户配置对象
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL) destroy;

/*!
 *  获取用户配置对象
 *
 *  @return 用户配置对象
 */
+(IFlySpeechUtility *) getUtility;

/*!
 *  设置MSC引擎的状态参数
 *
 *  @param value 参数值
 *  @param key   参数名称
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

@end
