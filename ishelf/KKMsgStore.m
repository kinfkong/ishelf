//
//  KKMsgStore.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgStore.h"
#import "KKMsgModel.h"


@implementation KKMsgStore

@synthesize url;
@synthesize identifier;

-(id) init {
	return [self initWithUpdateURL:nil andIdentifier:nil];
}

-(id) initWithUpdateURL:(NSString *) _url andIdentifier:(NSString *) _identifier {
	self.url = _url;
	self.identifier = _identifier;
	msgArray = [[NSMutableArray alloc] init];
	saveFile = nil;
	if (_identifier != nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			saveFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_list", _identifier]];
			[saveFile retain];
		}
	}
	return self;
}

-(void) dealloc {
	[saveFile release];
	[msgArray release];
	[url release];
	[identifier release];
	[super dealloc];
}


-(int) getMsgNum {
    return [msgArray count];
}

-(NSDictionary *) getMsgAtIndex:(int) index {
    int num = [self getMsgNum];
    if (index >= num) {
        return nil;
    }
    return [msgArray objectAtIndex:index];
}

-(int) refresh {
	int error = 0;
    int num = [msgArray	count];
    int msgId = 0;
    if (num == 0) {
        msgId = 0;
    } else {
        NSDictionary* msgInfo = [msgArray objectAtIndex:0];
        msgId = [[msgInfo objectForKey:@"id"] intValue];
    }
	
    NSArray* newMsgs = [KKMsgModel refreshWithBaseUrl:url 
									LargerThanMsgId:msgId maxNum:50 error:&error];
    if (newMsgs == nil) {
        return error;
    }
	
    int newNum = [newMsgs count];
    
    NSMutableArray* tmpMsgArray = [[NSMutableArray alloc] init];
    num = [newMsgs count];
    int totalNum = 0;
    for (int i = 0; i < num && totalNum < 50; i++) {
        [tmpMsgArray addObject:[newMsgs objectAtIndex:i]];
        totalNum++;
    }
	
    num = [msgArray count];
    for (int i = 0; i < num && totalNum < 50; i++) {
		NSDictionary* info1 = [msgArray objectAtIndex:i];
		NSString* uniqueField = [info1 objectForKey:@"unique_field"];
		if (uniqueField != nil) {
			id value1 = [info1 objectForKey:uniqueField];
			if (value1 != nil && [value1 isKindOfClass:[NSString class]]) {
				int j = 0;
				for (j = 0; j < totalNum; j++) {
					NSDictionary* info2 = [tmpMsgArray objectAtIndex:j];
					NSString* value2 = [info2 objectForKey:uniqueField];
					if ([value2 isEqualToString:value1]) {
						break;
					}
				}
				if (j < totalNum) {
					continue;
				}
			}
		}
        [tmpMsgArray addObject:[msgArray objectAtIndex:i]];
        totalNum++;
    }
    
    [msgArray release];
    msgArray = tmpMsgArray;
	
    return newNum;
}


-(int) more {
	int error = 0;
    int num = [self getMsgNum];
    int msgId = 0;
    if (num == 0) {
        msgId = 0;
    } else {
        NSDictionary* msgInfo = [msgArray objectAtIndex:[msgArray count] - 1];
        msgId = [[msgInfo objectForKey:@"id"] intValue];
    }
	
    NSArray* newMsgs = [KKMsgModel retrieveMoreWithBaseUrl:url 
										   LessThanMsgId:msgId maxNum:50 error:&error];
    if (newMsgs == nil) {
        return error;
    }
	
    if ([newMsgs count] == 0) {
        // nothing to reflesh
        return 0;
    }
	
    for (int i = 0; i < [newMsgs count]; i++) {
        [msgArray addObject:[newMsgs objectAtIndex:i]];
    }
	
	return [newMsgs count];
}

-(void) cleanAll {
	[msgArray removeAllObjects];
}

-(void) save {
	if (saveFile != nil) {
		[msgArray writeToFile:saveFile atomically:YES];
	}
}

-(void) load {
	if (saveFile != nil) {
		NSMutableArray *arrayFromFile = [NSMutableArray arrayWithContentsOfFile:saveFile];
		if (arrayFromFile != nil) {
			[msgArray release];
			msgArray = [arrayFromFile retain];
		}
	}
		
}

@end
