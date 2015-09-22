//
//  EAISpeechSynthesizer.m
//  englishapp
//
//  Created by LinShan Jiang on 15/4/2.
//
//


#import "EAISpeechSynthesizer.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "Definition.h"
#import "PcmPlayer.h"
#import "iflyMSC/IFlySpeechError.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"

static EAISpeechSynthesizer* sharedISS = nil;

@implementation EAISpeechSynthesizer
{
    PcmPlayer *ttsPlayer;
}

+(EAISpeechSynthesizer*)sharedInstance{
    if (sharedISS == nil) {
        sharedISS = [[EAISpeechSynthesizer alloc] init];
    }
    return sharedISS;
}

- (id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:@"Catherine" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //可以选择的其他设置项
    [self optionalSetting];
    
    ttsPlayer=[[PcmPlayer alloc]init];
    _luaFunDict = NULL;
    
    return self;
}

+(void)onStartSpeech:(NSDictionary *)dict{
    if (!dict || ![dict objectForKey:@"word"]) {
        NSLog(@"error! No words in dict");
        return;
    }
    NSString* words = [dict objectForKey:@"word"];
    [[EAISpeechSynthesizer sharedInstance]->ttsPlayer stop];
    [[EAISpeechSynthesizer sharedInstance]->_iFlySpeechSynthesizer stopSpeaking];

    if ([EAISpeechSynthesizer sharedInstance].state == NotStart && words && [words length] > 0)
    {
        [EAISpeechSynthesizer sharedInstance].hasError = NO;
        
        [EAISpeechSynthesizer sharedInstance].isCanceled = NO;
        [EAISpeechSynthesizer sharedInstance].synthesizeNotPlay=NO;
        
        [[EAISpeechSynthesizer sharedInstance].iFlySpeechSynthesizer startSpeaking:[words stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        if ([EAISpeechSynthesizer sharedInstance].iFlySpeechSynthesizer.isSpeaking) {
            [EAISpeechSynthesizer sharedInstance].state = Playing;
        }
    }
    
    NSLog(@"onStart end");
}

//合成后播放
+(void)onSynthesizeToUri:(NSDictionary *)dict{
    if (!dict || ![dict objectForKey:@"word"]) {
        NSLog(@"error! No words in dict");
        return;
    }
    NSString* words = [dict objectForKey:@"word"];
     if ([EAISpeechSynthesizer sharedInstance].state == NotStart && words && [words length] > 0)
    {
        [[EAISpeechSynthesizer sharedInstance]->ttsPlayer stop];               //首先停止播放器
        
        //删除旧文件
        NSString *dir=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        dir=[dir stringByAppendingPathComponent:@"synthesizeToUri.pcm"];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if([fileMgr fileExistsAtPath:dir])
        {
            NSError *err;
            BOOL ret = [fileMgr removeItemAtPath:dir error:&err];
            NSLog(@"remove file is=%d",ret);
        }
        
        [EAISpeechSynthesizer sharedInstance].hasError = NO;
        
        [EAISpeechSynthesizer sharedInstance].isCanceled = NO;
        [EAISpeechSynthesizer sharedInstance].synthesizeNotPlay=YES;

        NSLog(@"words:%@",words);
        [[EAISpeechSynthesizer sharedInstance].iFlySpeechSynthesizer  synthesize: [words stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] toUri:dir];
        
        if ([EAISpeechSynthesizer sharedInstance].iFlySpeechSynthesizer.isSpeaking)
        {
            [EAISpeechSynthesizer sharedInstance].state = Playing;
        }
        
    }
    NSLog(@"onSynthesizeToUri end");

}

+(void)registerScriptHandler:(NSDictionary *)dict{
    [EAISpeechSynthesizer sharedInstance].luaFunDict = [[NSDictionary alloc] initWithDictionary:dict];
}

-(void) optionalSetting{
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];

    // 可以自定义音频队列的配置（可选)，例如以下是配置连接非A2DP蓝牙耳机的代码
    //注意：
    //1. iOS 6.0 以上有效，6.0以下按类似方法配置
    //2. 如果仅仅使用语音合成TTS，并配置AVAudioSessionCategoryPlayAndRecord，可能会被拒绝上线appstore
    //    AVAudioSession * avSession = [AVAudioSession sharedInstance];
    //    NSError * setCategoryError;
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
    //        [avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&setCategoryError];
    //    }
    
    /*
     // 设置语音合成的参数【可选】
     
     //合成的语速,取值范围 0~100
     [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
     
     //合成的音量;取值范围 0~100
     [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
     
     //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
     [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
     
     //音频采样率,目前支持的采样率有 16000 和 8000;
     [_iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
     
     //设置是否返回事件
     [_iFlySpeechSynthesizer setParameter:@"1" forKey:@"tts_data_notify"];
     
     //设置音频保存，如果不需要则指定为nil
     [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
     
     */
    
    //    [_iFlySpeechSynthesizer setParameter:@"vixx" forKey:[IFlySpeechConstant VOICE_NAME]];
}

#pragma mark - IFlySpeechSynthesizerDelegate

/**
 * @fn      onSpeakBegin
 * @brief   开始播放
 *
 * @see
 */
- (void) onSpeakBegin
{
    NSLog(@"begin");
    self.isCanceled = NO;
    
    [ttsPlayer stop];               //首先停止播放器
    
    int callbackId = [[_luaFunDict objectForKey:@"luaOnSpeakBegin"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackId);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackId);
    cocos2d::LuaBridge::getStack()->executeFunction(0);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackId);
    
}

/**
 * @fn      onBufferProgress
 * @brief   缓冲进度
 *
 * @param   progress            -[out] 缓冲进度
 * @param   msg                 -[out] 附加信息
 * @see
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"bufferProgress:%d",progress);
}

/**
 * @fn      onSpeakProgress
 * @brief   播放进度
 *
 * @param   progress            -[out] 播放进度
 * @see
 */
- (void) onSpeakProgress:(int) progress
{
    NSLog(@"SpeakProgress:%d",progress);

}

/**
 * @fn      onSpeakPaused
 * @brief   暂停播放
 *
 * @see
 */
- (void) onSpeakPaused
{

    
    _state = Paused;

}

/**
 * @fn      onSpeakResumed
 * @brief   恢复播放
 *
 * @see
 */
- (void) onSpeakResumed
{

    _state = Playing;
    
}

/**
 * @fn      onCompleted
 * @brief   结束回调
 *
 * @param   error               -[out] 错误对象
 * @see
 */
- (void) onCompleted:(IFlySpeechError *) error
{
    NSLog(@"onCompleted error=%d",[error errorCode]);
    
    NSString *text = nil;
    
    if (self.isCanceled)
    {
        text = @"合成已取消";
    }
    else if (error.errorCode ==0 )
    {
        text = @"合成结束";
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        self.hasError = YES;
        NSLog(@"%@",text);
    }
    NSLog(@"completed:%@",text);
    
    //20019表示上次会话还没有结束错误
    if([error errorCode] != 20019)
    {

        _state = NotStart;
        
    }
    
    if( self.synthesizeNotPlay == YES && self.isCanceled == NO)    //对于synthesizeToUri接口，这里提供一个合成后，播放的功能
    {
        [ttsPlayer stop];               //首先停止播放器
        NSString *dir=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        dir=[dir stringByAppendingPathComponent:@"synthesizeToUri.pcm"];   //找到synthesizeToUri默认的保存文件路径 XXX/lib/caches/syntehsizeToUri.pcm
        NSLog(@"dir is %@",dir);
        
        [ttsPlayer setAudioData:dir];   //设置播放器的音频本地路径
        [ttsPlayer play];               //播放器开始播放音频
        
    }
    
    //调用lua回调函数
    int callbackID = [[_luaFunDict objectForKey:@"luaOnCompleted"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaValueDict item;
//    item["title"] = CCLuaValue::stringValue("hello");
    cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
    cocos2d::LuaBridge::getStack()->executeFunction(1);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
    
    
    //循环合成,注意waitUntilDone需要为NO，因为一次完整的合成会话实在本回调完全结束才终止的
    //    [self performSelectorOnMainThread:@selector(onStart:) withObject:nil waitUntilDone:NO];
}


/**
 * @fn      onSpeakCancel
 * @brief   正在取消
 *
 * @see
 */
- (void) onSpeakCancel
{
//    if (_isViewDidDisappear) {
//        return;
//    }
    
    self.isCanceled = YES;
    
//    [_bufferAlertView dismissModalView];
//    
//    _cancelAlertView.ParentView = self.view;
//    
//    [_cancelAlertView setText: @"正在取消..."];
//    
//    [_popUpView removeFromSuperview];
//    [self.view addSubview:_cancelAlertView];
}

@end
