//
//  KKMsgModel.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilModel.h"
#import "XMLHelper.h"

@interface KKMsgModel : NSObject {
	
}

//+(BOOL) sendMsg:(NSDictionary*) data; 

+(NSArray *) refreshWithBaseUrl:(NSString *) url LargerThanMsgId:(int) msgId maxNum:(int) maxNum error:(int *)error;

+(NSArray *) retrieveMoreWithBaseUrl:(NSString *) url LessThanMsgId:(int) msgId maxNum:(int) maxNum error:(int *)error;

+(NSArray *) retrieveMsgWithUrl:(NSString *) baseURL error:(int *) error;

@end
