//
//  ISEResultFinal.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/7.
//
//

#import "ISEResult.h"

@interface ISEResultFinal : ISEResult

@property(nonatomic,assign)int ret;
@property(nonatomic,assign)float total_score;

-(NSString*) toString;

@end
