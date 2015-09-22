//
//  EAISpeechSynthesizer.h
//  englishapp
//
//  Created by LinShan Jiang on 15/4/2.
//
//

#ifndef englishapp_EAISpeechSynthesizer_h
#define englishapp_EAISpeechSynthesizer_h

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@class IFlySpeechSynthesizer;

//合成的状态
typedef NS_OPTIONS(NSInteger, Status) {
    NotStart                 = 0,
    /**高，异常分析需要的级别*/
    Playing              = 2,
    
    Paused              = 4,
};

@interface EAISpeechSynthesizer : NSObject<IFlySpeechSynthesizerDelegate>

//合成对象
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;

//合成状态
@property (nonatomic)         Status                 state;

//存放lua回调函数
@property (nonatomic, retain)         NSDictionary*          luaFunDict;

@property (nonatomic)         BOOL                   isCanceled;
@property (nonatomic)         BOOL                   hasError;
@property (nonatomic)         BOOL                   synthesizeNotPlay;

-(id)init;
+(EAISpeechSynthesizer*)sharedInstance;
//合成后播放
+(void)onSynthesizeToUri:(NSDictionary*)dict;
//直接播放
+(void)onStartSpeech:(NSDictionary*)dict;
-(void)optionalSetting;
+(void)registerScriptHandler:(NSDictionary*)dict;
@end


#endif
