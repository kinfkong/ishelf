//
//  UIImageView+ASYNC.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import "UIImageView+ASYNC.h"

#import "UIImage+Cache.h"



@implementation UIImageView (async)

-(void) loadImageWithURL:(NSString *) url tmpImage:(UIImage *) tmpImage cache:(BOOL) cache delegate:(id<UIImageViewAsyncDelegate>) delegate withObject:(id) obj {
	if (tmpImage != nil) {
		self.image = tmpImage;
	}
	NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:url, @"url", obj, @"obj", nil];
	if (cache) {
		[imageInfo setObject:@"YES" forKey:@"cache"];
	}
	
	if (delegate != nil) {
		[imageInfo setObject:delegate forKey:@"delegate"];
	}
	
	if (obj != nil) {
		[imageInfo setObject:obj forKey:@"obj"];
	}
	
	[NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:imageInfo];
}


-(void) downloadImage:(NSMutableDictionary *) imageInfo {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[imageInfo retain];
	BOOL cache = NO;
	if ([imageInfo objectForKey:@"cache"] != nil) {
		cache = YES;
	}
	
	UIImage* image = [UIImage imageWithURL:[imageInfo objectForKey:@"url"] cache:cache];
	if (image != nil) {
		[imageInfo setObject:image forKey:@"image"];
		[self performSelectorOnMainThread:@selector(updateImage:) withObject:imageInfo waitUntilDone:YES];		
	}
	[imageInfo release];
	[pool release];
}

-(void)updateImage:(NSMutableDictionary *) imageInfo {
	UIImage *image = [imageInfo objectForKey:@"image"];
	id<UIImageViewAsyncDelegate> delegate = [imageInfo objectForKey:@"delegate"];
	if (delegate != nil && [delegate respondsToSelector:@selector(shouldUpdateImageView:)]) {
		id obj = [imageInfo objectForKey:@"obj"];
		if (![delegate shouldUpdateImageView:obj]) {
			return;
		}
	}
	self.image = image;
	if (delegate != nil && [delegate respondsToSelector:@selector(finishedLoadWithImage:)]) {
		[delegate finishedLoadWithImage:image];
	}
}

@end


