//
//  KKMsgModel.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgModel.h"
//#import "UserModel.h"
#import "UtilModel.h"


@implementation KKMsgModel

/*
+(BOOL) sendMsg:(NSDictionary*) data {
	NSString* msgPostURL = [[ConfigModel getInstance] getMsgPostURL];
	return [[UtilModel getInstance] postData:data toURL:msgPostURL];
}
 */



+(NSArray *) refreshWithBaseUrl:(NSString *) urlstr LargerThanMsgId:(int) msgId maxNum:(int) maxNum error:(int *)error {
	NSString* baseURL = [NSString stringWithFormat:@"%@/refresh/%d/%d", urlstr, msgId, maxNum];
	return [self retrieveMsgWithUrl:baseURL error:error];
}

+(NSArray *) retrieveMoreWithBaseUrl:(NSString *) urlstr LessThanMsgId:(int) msgId maxNum:(int) maxNum error:(int *)error {
	NSString* baseURL = [NSString stringWithFormat:@"%@/more/%d/%d", urlstr, msgId, maxNum];
	return [self retrieveMsgWithUrl:baseURL error:error];
}

+(NSArray *) retrieveMsgWithUrl:(NSString *) baseURL error:(int *) error {
	/*
	NSURL* url = [NSURL URLWithString:baseURL];
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
	 */
    /*
	NSDictionary* postData = [NSDictionary dictionaryWithObjectsAndKeys:[[UserModel getInstance] getUserName], @"user_name",
						  [[UserModel getInstance] getToken], @"token", nil];
     */
    
    NSDictionary* postData = [NSDictionary dictionaryWithObjectsAndKeys:@"dali", @"user_name",
                              @"dali", @"token", nil];
	NSURLRequest* urlRequest = [[UtilModel getInstance]  generateRequesWithURL:baseURL PostDictionary:postData];
	NSError* err = nil;
	NSURLResponse* response = nil;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&err];
	if (result == nil) {
		*error = -1;
		return nil;
	}
	XMLHelper* helper = [[XMLHelper alloc] init];
	NSDictionary* dict = [helper parseXML2Dictionary:result];
	[helper release];
	if (dict == nil) {
		// invalid format
		*error = -10;
		return nil;
	}
	NSString* errorStr = [dict objectForKey:@"errno"];
	if (errorStr == nil) {
		*error = -10;
		return nil;
	}
	*error = [errorStr intValue];
	if (*error != 0) {
		return nil;
	}
	
	if ([[dict objectForKey:@"detail"] isKindOfClass:[NSString class]]) {
		// empty
		return [[[NSArray alloc] init] autorelease];
	} else {
		return [dict objectForKey:@"detail"];
	}
}


@end
