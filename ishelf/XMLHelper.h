//
//  XMLHelper.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLHelper : NSObject <NSXMLParserDelegate> {
    NSString* currentText;
    NSMutableArray* stack;
    NSDictionary* root;
}

-(NSDictionary *) parseXML2Dictionary:(NSData *) data;

-(id) getParentWithCurrentName:(NSString *) name;
@end
