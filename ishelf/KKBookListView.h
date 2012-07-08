//
//  KKBookListView.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-17.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKBaseListView.h"

@protocol KKBookListViewDelegate;

@interface KKBookListView : KKBaseListView <KKBaseListViewDelegate> {
    id<KKBookListViewDelegate> bookListDelegate;
}


@property (nonatomic, retain) id<KKBookListViewDelegate> bookListDelegate;

@end


@protocol KKBookListViewDelegate <NSObject>

@optional
-(void) bookList:(KKBookListView*) bookList didTouchAt:(NSIndexPath *) indexPath;

@end