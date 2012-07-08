//
//  XMLHelper.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import "XMLHelper.h"


@implementation XMLHelper

-(id) init {
	[super init];
    root = nil;
    currentText = nil;
    stack = [[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc {
    [stack release];
    [super dealloc];
}

-(NSDictionary *) parseXML2Dictionary:(NSData *) data {
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	return [root autorelease];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {

    // empty content
    [stack addObject:@""];
}


-(void) parser:(NSXMLParser *) parser foundCharacters:(NSString *) string {
    //NSLog(@"the string before clean[%@]", string);
	NSString* cleanString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // ignore the empty string
	if ([cleanString length] == 0) {
		return;
	}
    if (currentText == nil) {
        currentText = [NSString stringWithString:string];
    } else {
        currentText = [NSString stringWithFormat:@"%@%@", currentText, string];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	id current = nil;
	if (currentText != nil) {
		current = [currentText retain];
		currentText = nil;
		
	} else {
		current = [[stack lastObject] retain];
	}
	
	[stack removeLastObject];

    id parent = [self getParentWithCurrentName:elementName];
    if (parent == nil) {
        root = [current retain];
    } else {
        if ([parent isKindOfClass:[NSMutableArray class]]) {
            [parent addObject:current];
        } else {
            [parent setObject:current forKey:elementName];
        }
    }

    [current release];
}

-(id) getParentWithCurrentName:(NSString *) elementName {
    id parent = [stack lastObject];
    if ([parent isKindOfClass:[NSString class]] && [(NSString*) parent length] == 0) {
        if ([elementName isEqualToString:@"item"]) {
            parent = [[NSMutableArray alloc] init];
        } else {
            parent = [[NSMutableDictionary alloc] init];
        }

        // init parent
        [stack removeLastObject];

        [stack addObject:parent];

        [parent release];

        parent = [stack lastObject];
    }
    return parent;
}

@end
