//
//  UIImageView+ASYNC.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIImageViewAsyncDelegate;

@interface UIImageView (async) 

-(void) loadImageWithURL:(NSString *) url tmpImage:(UIImage *) tmpImage cache:(BOOL) cache delegate:(id<UIImageViewAsyncDelegate>) delegate withObject:(id) obj;

@end


@protocol UIImageViewAsyncDelegate <NSObject>
@optional
-(BOOL) shouldUpdateImageView:(id) obj;
-(void) finishedLoadWithImage:(UIImage *) image;

@end