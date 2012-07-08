//
//  KKLoginController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-11-16.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConnect.h"

@interface KKLoginController : UIViewController <WBSessionDelegate,WBSendViewDelegate,WBRequestDelegate> {
    WeiBo* weibo;
}

@property (nonatomic,assign,readonly) WeiBo* weibo;

@end
