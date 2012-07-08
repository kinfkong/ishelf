//
//  KKNetworkLoadingView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-17.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKNetworkLoadingViewDelegate;


@interface KKNetworkLoadingView : UIView {
	NSMutableData* receivedData;
	id<KKNetworkLoadingViewDelegate> delegate;
}

@property(nonatomic, retain) id<KKNetworkLoadingViewDelegate> delegate;

-(id) initWithRequest:(NSURLRequest *) request delegate:(id<KKNetworkLoadingViewDelegate>) _delegate;

-(id) initWithRequest:(NSURLRequest *) request delegate:(id<KKNetworkLoadingViewDelegate>) _delegate tag:(NSInteger) _tag1;
@end

@protocol KKNetworkLoadingViewDelegate <NSObject>

@optional

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data;
-(void) view:(KKNetworkLoadingView *) sender  onFailedLoading:(NSError *) error;
-(NSString*) loadingMessageForView:(KKNetworkLoadingView *) sender;

-(NSString*) failedMessageForView:(KKNetworkLoadingView *) sender;

@end

