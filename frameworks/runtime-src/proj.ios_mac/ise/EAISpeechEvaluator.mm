//
//  EAISpeechEvaluator.m
//  englishapp
//
//  Created by LinShan Jiang on 15/4/1.
//
//

#import "EAISpeechEvaluator.h"
#import "ISEParams.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"
#import "iflyMSC/IFlySpeechError.h"

@interface EAISpeechEvaluator () <IFlySpeechEvaluatorDelegate,ISEResultXmlParserDelegate>
@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, strong) NSString* resultText;
@property (nonatomic, assign) BOOL isSessionEnd;
@end

static EAISpeechEvaluator* sharedISE = nil;

@implementation EAISpeechEvaluator

+ (EAISpeechEvaluator*)sharedInstance{
    if (sharedISE == nil) {
        sharedISE = [[EAISpeechEvaluator alloc] init];
    }
    return sharedISE;
}

//- (instancetype) init{
- (id) init{

    self = [super init];
    if (!self) {
        return nil;
    }
    
    _iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    _iFlySpeechEvaluator.delegate = self;
    
    self.resultText = @"";
    
    //清空参数
    [_iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    self.iseParams = [ISEParams createDefaultParams];
    [self reloadParams];
    self.isSessionEnd = YES;
    return self;
}

+(void)startSpeechEvaluate:(NSDictionary*)dict{
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    BOOL isUTF8=[[[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator  parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    BOOL isZhCN=[[[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator  parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
    
    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
    NSString* text = @"[word]\nHello";
    if(needAddTextBom){
        if(text && [text length]>0){
            Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
            buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
            [buffer appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
            NSLog(@"zhBuffer:%@",[buffer base64Encoding]);
        }
    }else{
        //self.textView.text为传入需要识别的单词表如：
        // [word]  //[word]为默认表头
        // apple   //每行一个单词
        // banana
        // orange
        
        buffer= [NSMutableData dataWithData:[text dataUsingEncoding:encoding]];
        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
        NSLog(@"enBuffer:%s",[text cStringUsingEncoding:NSUTF8StringEncoding]);
        
    }

    [EAISpeechEvaluator sharedInstance].resultText = @"";
    //开始评测，主要参数为需要评测的单词表
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator startListening:buffer params:nil];
    [EAISpeechEvaluator sharedInstance].isSessionEnd = NO;

}

+(void)stopSpeechEvaluate{
    NSLog(@"stop speech");
    if (![EAISpeechEvaluator sharedInstance].isSessionEnd) {
        [EAISpeechEvaluator sharedInstance].resultText = @"";
    }
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator stopListening];
    [EAISpeechEvaluator sharedInstance].resultText = @"";
}

+(void)cancelSpeechEvaluate{
    [[EAISpeechEvaluator sharedInstance].iFlySpeechEvaluator cancel];
    [EAISpeechEvaluator sharedInstance].resultText = @"";
}

+(void)setNewParams:(NSDictionary *)dict{
    //lua调用的接口。
    //通过dict传入新的params，比如由单词变为句子，由英文变为中文
    //解析这个dict，给[EAISpeechEvaluator sharedInstance].iseParams赋值
    //[[EAISpeechEvaluator sharedInstance] reloadParams];
}

+(void)registerScriptHandler:(NSDictionary *)dict{
    [EAISpeechEvaluator sharedInstance].luaFunDict = [[NSDictionary alloc] initWithDictionary:dict];
}

-(void)onParse{
    ISEResultXmlParser* parser = [[ISEResultXmlParser alloc] init];
    parser.delegate = self;
    [parser parserXml:self.resultText];
}

-(void)reloadParams{
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
}

#pragma mark - IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    int callbackID = [[_luaFunDict objectForKey:@"luaOnVolumeChanged"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->pushInt(volume);
    cocos2d::LuaBridge::getStack()->executeFunction(1);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
}

/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
    int callbackID = [[_luaFunDict objectForKey:@"luaOnBeginOfSpeech"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->executeFunction(0);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech {
    int callbackID = [[_luaFunDict objectForKey:@"luaOnEndOfSpeech"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->executeFunction(0);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
}

/*!
 *  正在取消
 */
- (void)onCancel {
    int callbackID = [[_luaFunDict objectForKey:@"luaOnCancel"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->executeFunction(0);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
}

/*!
 *  评测结果回调
 *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
 *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
 *  数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onError:(IFlySpeechError *)errorCode {
    NSLog(@"error,%@",[NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]]);
    int ec = (int)[errorCode errorCode];
    std::string desc = [[errorCode errorDesc] cStringUsingEncoding:NSUTF8StringEncoding];
    int callbackID = [[_luaFunDict objectForKey:@"luaOnError"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->pushInt(ec);
    cocos2d::LuaBridge::getStack()->pushString(desc.c_str());
    cocos2d::LuaBridge::getStack()->executeFunction(2);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
    
    //todo
    
    //    if(errorCode && errorCode.errorCode!=0){
    //        [self.popupView setText:[NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]]];
    //        [self.view addSubview:self.popupView];
    //
    //    }
    //
    //    [self performSelectorOnMainThread:@selector(resetBtnSatus:) withObject:errorCode waitUntilDone:NO];
    
}

/*!
 *  评测结果回调
 *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast{
    NSLog(@"results");
        if (results) {
            NSString *showText = @"";
    
            const char* chResult=(const char*)[results bytes];
    
            BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
            NSString* strResults=nil;
            if(isUTF8){
                strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
            }else{
                NSLog(@"result encoding: gb2312");
                NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
            }
            if(strResults){
                showText = [showText stringByAppendingString:strResults];
                NSLog(@"showText:%@",showText);
            }
    
            self.resultText=showText;
//            self.resultView.text = showText;
//            self.isSessionResultAppear=YES;
            self.isSessionEnd=YES;
            if(isLast){
                NSLog(@"评测结束");
//                [self.popupView setText:@"评测结束"];
//                [self.view addSubview:self.popupView];
                [self onParse];
            }
            [self onParse];
            
            std::string rt = [strResults cStringUsingEncoding:NSUTF8StringEncoding];
            int callbackID = [[_luaFunDict objectForKey:@"luaOnResults"] intValue];
            cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
            cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
            cocos2d::LuaBridge::getStack()->pushString(rt.c_str());
            cocos2d::LuaBridge::getStack()->pushBoolean(isLast);
            cocos2d::LuaBridge::getStack()->executeFunction(2);
            cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
            

        }
        else{
            if(isLast){
                //没有声音录入
                NSLog(@"你好像没有说话哦");
//                [self.popupView setText:@"你好像没有说话哦"];
//                [self.view addSubview:self.popupView];
            }
            self.isSessionEnd=YES;
        }
//        self.startBtn.enabled=YES;
}

#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result{
    //    self.resultView.text=[result toString];
    NSLog(@"total score:%f",result.total_score);
    int callbackID = [[_luaFunDict objectForKey:@"luaOnParserResult"] intValue];
    cocos2d::LuaBridge::pushLuaFunctionById(callbackID);
    cocos2d::LuaBridge::retainLuaFunctionById(callbackID);
    cocos2d::LuaBridge::getStack()->pushFloat(result.total_score);

    cocos2d::LuaBridge::getStack()->executeFunction(1);
    cocos2d::LuaBridge::releaseLuaFunctionById(callbackID);
//    NSLog(@"result:%@",[result toString]);
}

@end