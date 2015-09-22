//
//  EAISpeechEvaluator.h
//  englishapp
//
//  Created by LinShan Jiang on 15/4/1.
//
//

#ifndef englishapp_EAISpeechEvaluator_h
#define englishapp_EAISpeechEvaluator_h

#import <Foundation/Foundation.h>
@class ISEParams;

@interface EAISpeechEvaluator : NSObject
@property (nonatomic, strong) ISEParams* iseParams;
@property (nonatomic, retain) NSDictionary* luaFunDict;

-(id)init;
+(EAISpeechEvaluator*)sharedInstance;
+(void)startSpeechEvaluate:(NSDictionary*)dict;
+(void)stopSpeechEvaluate;
+(void)cancelSpeechEvaluate;
+(void)setNewParams:(NSDictionary*)dict;
+(void)registerScriptHandler:(NSDictionary*)dict;

-(void)onParse;
-(void)reloadParams;

//-(void)on
@end


#endif
