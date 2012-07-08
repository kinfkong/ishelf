//
//  KKBaseListView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-16.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKBaseListView.h"


@implementation KKBaseListView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KKBaseListViewDelegate>) _delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.delegate = _delegate;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		tableView.delegate = self;
		tableView.dataSource = self;
		[self addSubview:tableView];
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
																						 -tableView.bounds.size.height, 
																						 tableView.frame.size.width, 
																						 self.bounds.size.height)]; 
		
		_refreshHeaderView.delegate = self; 
		[tableView addSubview:_refreshHeaderView];
		[_refreshHeaderView refreshLastUpdatedDate];
		
		footerView = nil;
		
		updateLock = [[NSCondition alloc] init];
		NSString* identifier = nil;
		if ([self.delegate respondsToSelector:@selector(getSaveIdentifier)]) {
			identifier = [self.delegate getSaveIdentifier];
		}
		msgStore = [[KKMsgStore alloc] initWithUpdateURL:nil andIdentifier:identifier];
		[msgStore load];
		[tableView reloadData];
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[delegate release];
	[tableView release];
	
	[footerView release];
	[_refreshHeaderView release];
	[msgStore release];
    [super dealloc];
}


-(void) reloadTableViewDataSource {
	_reloading = YES;
}

-(void) doneLoadingTableViewData:(id) obj {
	_reloading = NO;
	
	[tableView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
	
}

-(void) doneLoadingMoreTableViewData:(NSNumber *) number {
	[footerView kkMoreScrollViewDataSourceDidFinishedLoading:tableView];
	
	if ([number intValue] > 0) {
		[tableView reloadData];
		
		[footerView removeFromSuperview];
		footerView = nil;
	}
	
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
	if (footerView == nil && [msgStore getMsgNum] >= 40 && scrollView.contentSize.height >= scrollView.frame.size.height) {
		footerView = [[KKMoreTableFooterView alloc] initWithFrame:CGRectMake(0, scrollView.contentSize.height, scrollView.frame.size.width, scrollView.frame.size.height)];
		footerView.delegate = self;
		[tableView addSubview:footerView];	
	}
	[footerView kkMoreScrollViewDidScroll:scrollView];
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{ 
    [self reloadTableViewDataSource];
	[NSThread detachNewThreadSelector:@selector(refreshMsgList:) toTarget:self withObject:nil];
}

- (void)kkMoreTableFooterDidTriggerMore:(KKMoreTableFooterView*)view {
	[NSThread detachNewThreadSelector:@selector(moreMsgList:) toTarget:self withObject:nil];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{ 
    return _reloading; 
} 

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{ 
    return [NSDate date];
}

-(void) refresh {
	[tableView setContentOffset:CGPointMake(0, -100)];
	[self scrollViewDidEndDragging:tableView willDecelerate:NO];
}

-(NSDictionary *) getMsgDataAt:(NSIndexPath *) indexPath {
	return [msgStore getMsgAtIndex:[indexPath row]];
}

-(void) cleanAll {
	[msgStore cleanAll];
	[msgStore save];
	[tableView reloadData];
}

-(void) refreshMsgList:(id) obj {
	[updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[msgStore refresh];
	[msgStore save];
	[self performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:nil waitUntilDone:YES];
	[pool release];
	[updateLock unlock];
}

-(void) moreMsgList:(id) obj {
	[updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int moreNum = [msgStore more];
	[msgStore save];
	NSNumber* number = [NSNumber numberWithInt:moreNum];
	[self performSelectorOnMainThread:@selector(doneLoadingMoreTableViewData:) withObject:number waitUntilDone:YES];
	[pool release];
	[updateLock unlock];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [msgStore getMsgNum];
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	NSDictionary * data = [msgStore getMsgAtIndex:[indexPath row]];
	return [self.delegate cellHeight:data tableView:_tableView];
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.delegate tableView:_tableView cellForRowAtIndexPath:indexPath data:[msgStore getMsgAtIndex:[indexPath row]]];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([delegate respondsToSelector:@selector(listDidTouchAt:)]) {
		[delegate listDidTouchAt:indexPath];
	}
}

-(void) setURL:(NSString *) url {
	msgStore.url = url;
}

@end
