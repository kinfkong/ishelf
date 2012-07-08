//
//  KKMoreTableFooterView.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKMoreTableFooterDelegate;

@interface KKMoreTableFooterView : UIView {
	BOOL loading;
	id<KKMoreTableFooterDelegate> delegate;
}

@property(nonatomic, retain) id<KKMoreTableFooterDelegate> delegate;

-(void) kkMoreScrollViewDidScroll:(UIScrollView *) scrollView;
-(void) kkMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *) scrollView;

@end

@protocol KKMoreTableFooterDelegate <NSObject>
@optional
- (void)kkMoreTableFooterDidTriggerMore:(KKMoreTableFooterView*)view;

@end

