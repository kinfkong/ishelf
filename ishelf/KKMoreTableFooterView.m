//
//  KKMoreTableFooterView.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMoreTableFooterView.h"


@implementation KKMoreTableFooterView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 20)];
		label.text = @"正在载入更多...";
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		[label release];
		loading = NO;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(30, 20, 20.0f, 20.0f);
		[view startAnimating];
		[self addSubview:view];
		
		[view release];
    }
    return self;
}


-(void) kkMoreScrollViewDidScroll:(UIScrollView *) scrollView {
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
		&& !loading) {
		loading = YES;
		if ([delegate respondsToSelector:@selector(kkMoreTableFooterDidTriggerMore:)]) {
			[delegate kkMoreTableFooterDidTriggerMore:self];
		}
	}
}

-(void) kkMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *) scrollView {
	loading = FALSE;
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
    [super dealloc];
}



@end
