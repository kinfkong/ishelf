//
//  KKBookListView.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-17.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKBookListView.h"


@implementation KKBookListView

@synthesize bookListDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame delegate:self];
    if (self) {
		//[self refresh];
        // Initialization code.
		/*
		 UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40) ];
		 label.text = @"This is the user list ...";
		 [self addSubview:label];
		 [label release];
		 */
    }
    return self;
}

-(void) dealloc {
    [self.bookListDelegate release];
    [super dealloc];
}

-(CGFloat) cellHeight:(NSDictionary *) data tableView:(UITableView *) _tableView {
    //NSLog(@"here!!!");
	return 90;
}

-(UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *) data {
	static NSString* identifier = @"KKBookListViewCell";
	UITableViewCell* msgCell = (UITableViewCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
	if (msgCell == nil) {
		msgCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
		UIImageView* bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 3, 60, 84)];
		bookImageView.tag = 321;
		[msgCell addSubview:bookImageView];
		[bookImageView release];
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(72, 8, 196, 18)];
        title.tag = 11111;
        [msgCell addSubview:title];
        [title release];
        title.font = [UIFont boldSystemFontOfSize:16];
        //title.backgroundColor = [UIColor redColor];
        
        UILabel* status = [[UILabel alloc] initWithFrame:CGRectMake(270, 8, 40, 18)];
        status.tag = 88888;
        [msgCell addSubview:status];
        [status release];
        status.font = [UIFont systemFontOfSize:14];
        // status.backgroundColor = [UIColor blueColor];
        // title.text = [data objectForKey:@"title"];
        
        UILabel* author = [[UILabel alloc] initWithFrame:CGRectMake(72, 30, 300 - 72, 16)];
        author.tag = 22222;
        author.textColor = [UIColor grayColor];
        [msgCell addSubview:author];
        [author release];
        //author.text = [data objectForKey:@"author"];
        author.font = [UIFont systemFontOfSize:14];
        
        
        UILabel* pubInfo = [[UILabel alloc] initWithFrame:CGRectMake(72, 48, 300 - 72, 16)];
        pubInfo.tag = 33333;
        [msgCell addSubview:pubInfo];
        [pubInfo release];
        //author.text = [data objectForKey:@"author"];
        pubInfo.textColor = [UIColor grayColor];
        pubInfo.font = [UIFont systemFontOfSize:14];
		
        UILabel* rating = [[UILabel alloc] initWithFrame:CGRectMake(72, 66, 300 - 72, 16)];
        rating.tag = 44444;
        [msgCell addSubview:rating];
        [rating release];
        //author.text = [data objectForKey:@"author"];
        rating.textColor = [UIColor grayColor];
        rating.font = [UIFont systemFontOfSize:14];
        
        /*
		bookImageView.layer.masksToBounds = YES;
		bookImageView.layer.cornerRadius = 4.0;
		bookImageView.layer.borderWidth = 0.0;
		bookImageView.layer.borderColor = [[UIColor clearColor] CGColor];
		bookImageView.userInteractionEnabled = YES;
		*/
        /*
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 320 - 120, 25)];
		label.font = [UIFont boldSystemFontOfSize:16.0f];
		label.tag = 100;
		[msgCell addSubview:label];
		[label release];
		
		UILabel* namelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 320 - 120, 20)];
		namelabel.font = [UIFont systemFontOfSize:18.0f];
		namelabel.tag = 101;
		namelabel.textColor = [UIColor grayColor];
		[msgCell addSubview:namelabel];
		[namelabel release];
         */
	}
	
    msgCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	UIImageView* bookImageView = (UIImageView *) [msgCell viewWithTag:321];
	NSString* msgId = [data objectForKey:@"id"];
	NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", nil];

    NSString* url = [data objectForKey:@"image"];
	[bookImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
    UILabel* title = (UILabel *) [msgCell viewWithTag:11111];
    title.text = [data objectForKey:@"title"];
    UILabel* author = (UILabel *) [msgCell viewWithTag:22222];
    author.text = [data objectForKey:@"author"];
    
    UILabel* pubInfo = (UILabel *) [msgCell viewWithTag:33333];
    NSString* pubStr = [NSString stringWithFormat:@"%@ / %@", [data objectForKey:@"pubdate"] == nil ? @"" : [data objectForKey:@"pubdate"], [data objectForKey:@"publisher"] == nil ? @"" : [data objectForKey:@"publisher"]];
    pubInfo.text = pubStr;
    
    
    UILabel* rating = (UILabel *) [msgCell viewWithTag:44444];
    NSString* ratingStr = [NSString stringWithFormat:@"评分: %@分", [data objectForKey:@"rating"] == nil ? @"0" : [data objectForKey:@"rating"]];
    rating.text = ratingStr;
    
    UILabel* status = (UILabel *) [msgCell viewWithTag:88888];
    NSString* statusStr = @"";
    NSString* tstr = [data objectForKey:@"status"];
    if ([tstr isEqualToString:@"reading"]) {
        status.textColor = [UIColor colorWithRed:0 / 256. green:(8 * 16 + 11) / 256. blue:0 / 256. alpha:1.0];
        //status.textColor = [UIColor greenColor];
        statusStr = @"在读";
    } else if ([tstr isEqualToString:@"unread"]) {
        status.textColor = [UIColor grayColor];
        statusStr = @"未读";
    } else if ([tstr isEqualToString:@"read"]) {
        //status.textColor = [UIColor blueColor];
        status.textColor = [UIColor colorWithRed:(8 * 16 + 11) / 256. green:0. / 256. blue:0 / 256. alpha:1.0];
        statusStr = @"已读";
    }
    status.text = statusStr;
	/*
	UILabel* label = (UILabel *) [msgCell viewWithTag:100];
    //NSLog(@"the description:%@", data);
	label.text = [data objectForKey:@"description"];
	
	UILabel* namelabel = (UILabel *) [msgCell viewWithTag:101];
	//namelabel.text = [NSString stringWithFormat:@"(%.3lf, %.3lf)", [lng doubleValue] , [lat doubleValue]];
	namelabel.text = @"";
     */
	return msgCell;
	
}

-(void) listDidTouchAt:(NSIndexPath *) indexPath {
    if ([self.bookListDelegate respondsToSelector:@selector(bookList:didTouchAt:)]) {
		[self.bookListDelegate bookList:self didTouchAt:indexPath];
	}
}


@end
