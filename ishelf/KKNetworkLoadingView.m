//
//  KKNetworkLoadingView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-17.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKNetworkLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "XMLHelper.h"


@implementation KKNetworkLoadingView

@synthesize delegate;
- (id)initWithRequest:(NSURLRequest *) request delegate:(id<KKNetworkLoadingViewDelegate>) _delegate {
	return [self initWithRequest:request delegate:_delegate tag:0];
}
- (id)initWithRequest:(NSURLRequest *) request delegate:(id<KKNetworkLoadingViewDelegate>) _delegate tag:(NSInteger) _tag1 {
    CGFloat width = 100;
	CGFloat height = 100;
    self = [super initWithFrame:CGRectMake((320 - width) * 0.5, 110, width, height)];
	self.delegate = _delegate;
	self.tag = _tag1;
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 8.0;
		self.layer.borderWidth = 0.0;
		self.layer.borderColor = [[UIColor clearColor] CGColor];
		self.userInteractionEnabled = YES;
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, width, 50)];
		label.backgroundColor = [UIColor clearColor];
		if ([self.delegate respondsToSelector:@selector(loadingMessageForView:)]) {
			label.text = [self.delegate loadingMessageForView:self];
		} else {
			label.text = @"加载中...";
		}
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.tag = 222;
		[self addSubview:label];
		[label release];
		
		
		UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30.f, 30.f)]; 
		[activityIndicator setCenter:CGPointMake(width / 2, height / 2 - 10)];
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.tag = 111;
		[self addSubview:activityIndicator];
		[activityIndicator startAnimating];
		[activityIndicator release];
		
		UILabel* tmpLabel = [[UILabel alloc] initWithFrame:activityIndicator.frame];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.text = @"!";
		tmpLabel.font = [UIFont systemFontOfSize:30];
		tmpLabel.textAlignment = UITextAlignmentCenter;
		tmpLabel.textColor = [UIColor whiteColor];
		tmpLabel.tag = 333;
		[self addSubview:tmpLabel];
		tmpLabel.hidden = YES;
		[tmpLabel release];
		
		receivedData = [[NSMutableData alloc] init];
		[NSURLConnection connectionWithRequest:request delegate:self];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"receving ...");
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*) [self viewWithTag:111];
	[activityIndicator stopAnimating];
	//self.hidden = YES;
	/*
	NSString* result = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
	NSLog(@"the result:%@", result);
	*/
	XMLHelper* helper = [[XMLHelper alloc] init];
	NSDictionary* dict = [helper parseXML2Dictionary:receivedData];
	[helper release];
	if (dict == nil) {
		return [self connection:connection didFailWithError:nil];
	} 
	//NSLog(@"The data:%@", dict);
	if ([self.delegate respondsToSelector:@selector(view:onFinishedLoading:)]) {
		[self.delegate view:self onFinishedLoading:dict];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//NSLog(@"failed ...");
	UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*) [self viewWithTag:111];
	[activityIndicator stopAnimating];
	
	UILabel* label = (UILabel *) [self viewWithTag:222];
	if ([self.delegate respondsToSelector:@selector(failedMessageForView:)]) {
		label.text = [self.delegate failedMessageForView:self];
	} else {
		label.text = @"加载失败";
	}
	
	UILabel* tmpLabel = (UILabel *) [self viewWithTag:333];
	tmpLabel.hidden = NO;
	
	// fade out
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
	
	if ([self.delegate respondsToSelector:@selector(view:onFailedLoading:)]) {
		[self.delegate view:self onFailedLoading:error];
	}
}

- (void)dealloc {
	[receivedData release];
	[delegate release];
    [super dealloc];
}



@end
