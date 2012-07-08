//
//  KKMsgStore.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKMsgStore : NSObject {
	NSMutableArray* msgArray;
	NSString* url;
	NSString* identifier;
	NSString* saveFile;
}

@property(nonatomic, retain) NSString* url;
@property(nonatomic, retain) NSString* identifier;

-(id) initWithUpdateURL:(NSString *) url andIdentifier:(NSString *) identifier;

-(int) getMsgNum;

-(NSDictionary *) getMsgAtIndex:(int) index;

-(int) refresh;
-(int) more;

-(void) cleanAll;
-(void) save;
-(void) load;

@end
