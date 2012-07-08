//
//  KKBaseListView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-16.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "KKMoreTableFooterView.h"
#import "KKMsgStore.h"
#import "UIImageView+ASYNC.h"

@protocol KKBaseListViewDelegate;


@interface KKBaseListView : UIView <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, KKMoreTableFooterDelegate, UIImageViewAsyncDelegate>{
	id<KKBaseListViewDelegate> delegate;
	UITableView* tableView;
	
	EGORefreshTableHeaderView* _refreshHeaderView;
	KKMoreTableFooterView* footerView;
	BOOL _reloading;
	KKMsgStore* msgStore;
	NSCondition* updateLock;
}

@property(nonatomic, retain) id<KKBaseListViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id<KKBaseListViewDelegate>) _delegate;

-(void) refresh;
-(void) cleanAll;

-(NSDictionary *) getMsgDataAt:(NSIndexPath *) indexPath;

-(void) setURL:(NSString *) url;

@end

@protocol KKBaseListViewDelegate <NSObject>

@required
-(CGFloat) cellHeight:(NSDictionary *) data tableView:(UITableView *) _tableView;
-(UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *) data;

@optional
-(NSString *) getSaveIdentifier;
-(void) listDidTouchAt:(NSIndexPath *) indexPath;
@end
