//
//  UIImage+Cache.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (cache)

+(UIImage *) imageWithURL:(NSString *) url cache:(BOOL) cache;

@end
