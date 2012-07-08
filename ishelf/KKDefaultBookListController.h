//
//  KKDefaultBookListController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-17.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBookListView.h"


@interface KKDefaultBookListController : UIViewController <KKBookListViewDelegate, UIActionSheetDelegate> {
    KKBookListView* bookListView;
    NSString* status;
}

-(id) initWithStatus:(NSString *) _status;

@property(nonatomic, retain) NSString* status;

@end
