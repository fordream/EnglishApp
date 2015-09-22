//
//  IFlySpeechSynthesizerDelegate.h
//  MSC
//
//  Created by ypzhao on 13-3-20.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechEvent.h"

@class IFlySpeechError;

/*!
 语音合成回调
 */
@protocol IFlySpeechSynthesizerDelegate <NSObject>

@required

/*!
 *  结束回调
 *   当整个合成结束之后会回调此函数
 *
 *  @param error 错误描述
 */
- (void) onCompleted:(IFlySpeechError*) error;

@optional

/*!
 *  开始合成回调
 */
- (void) onSpeakBegin;

/*!
 *  缓冲进度回调
 *
 *  @param progress 缓冲进度，0-100
 *  @param msg      附加信息，此版本为nil
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg;

/*!
 *  播放进度回调
 *
 *  @param progress 播放进度，0-100
 */
- (void) onSpeakProgress:(int) progress;

/*!
 *  暂停播放回调
 */
- (void) onSpeakPaused;

/*!
 *  恢复播放回调
 */
- (void) onSpeakResumed;

/*!
 *  正在取消回调
 *   当调用`cancel`之后会回调此函数
 */
- (void) onSpeakCancel;

/*!
 *  扩展事件回调
 *
 *  @param eventType 事件类型，具体参见IFlySpeechEvent枚举。目前只支持IFly_EVENT_TTS_BUFFER也就是实时返回合成音频。
 *  @param arg0      参数0
 *  @param arg1      参数1
 *  @param eventData 数据
 */
- (void) onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData;

@end
