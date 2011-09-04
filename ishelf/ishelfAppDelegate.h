//
//  ishelfAppDelegate.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-4.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ishelfViewController;

@interface ishelfAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ishelfViewController *viewController;

@end
