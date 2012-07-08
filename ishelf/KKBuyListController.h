//
//  KKBuyListController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-20.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBookListView.h"


@interface KKBuyListController : UIViewController <KKBookListViewDelegate> {
    NSString* url;
}

-(id) initWithBookURL:(NSString *) _url;

@property(nonatomic, retain) NSString* url;

@end

