//
//  UIImage+Cache.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import "UIImage+Cache.h"

#import <commoncrypto/CommonDigest.h>  



@interface UIImage (cache_private)
+(NSString *) getFilePathOfURL:(NSString *) url;
+(NSString*) md5:(NSString*) str;
@end

@implementation UIImage (cache)

+(NSString*) md5:(NSString*) str {  
    const char *cStr = [str UTF8String];  
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    CC_MD5( cStr, strlen(cStr), result );  
	
    return [NSString stringWithFormat:  
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",  
            result[0], result[1], result[2], result[3],  
            result[4], result[5], result[6], result[7],  
            result[8], result[9], result[10], result[11],  
            result[12], result[13], result[14], result[15]  
            ];  
}  

+(NSString *) getFilePathOfURL:(NSString *) url {
	NSString* name = [UIImage md5:url];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:name];
	return fullPath;
}

+(UIImage *) imageWithURL:(NSString *) url cache:(BOOL) cache {
	NSString* filePath = [UIImage getFilePathOfURL:url];
	UIImage* image = [UIImage imageWithContentsOfFile:filePath];
	if (image == nil) {
				NSLog(@"here1:url%@", url);
		NSData* content = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		NSLog(@"the content length:%d", [content length]);
		image = [UIImage imageWithData:content];
		NSLog(@"here2:%@", image);
		NSData *data = UIImagePNGRepresentation(image);
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager createFileAtPath:filePath contents:data attributes:nil];
	}
	return image;
}

@end
