//
//  UtilModel.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UtilModel : NSObject {

}

+(UtilModel *) getInstance;

-(BOOL) postData:(NSDictionary *) data toURL:(NSString *) url;

-(NSData *) generateFormDataFromPostDictionary:(NSDictionary *) dict;

-(NSURLRequest *) generateRequesWithURL:(NSString*) baseURL PostDictionary:(NSDictionary *) dict;


-(NSString *) getReadableDateDiffBetweenDate1:(NSString *) date1 andDate2:(NSString *) date2;

-(NSString *) getReplyMsg:(NSDictionary *) data;
@end
