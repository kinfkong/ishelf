//
//  KKDefaultBookListController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-17.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKDefaultBookListController.h"
#import "KKBookInfoController.h"
#import "XMLHelper.h"
#import "UtilModel.h"

@interface KKDefaultBookListController (private)
-(void) changeBookStatus:(NSString *) _status;
@end

@implementation KKDefaultBookListController

@synthesize status;



-(id) initWithStatus:(NSString *)_status  {
    self = [super init];
    if (self != nil) {
        self.status = _status;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [bookListView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) setViewTitle:(NSString *) title {
    self.navigationItem.title = title;
}

- (void)loadView {
	[super loadView];
    //self.title = @"test";
    //NSLog(@"here !!!");
	bookListView = [[KKBookListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	bookListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bookListView.bookListDelegate = self;
	
	[self.view addSubview:bookListView];
	    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 release];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAll)];
	self.navigationItem.rightBarButtonItem = item2;
    [item2 release];
    
    [self changeBookStatus:self.status];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) bookList:(KKBookListView*) bookList didTouchAt:(NSIndexPath *) indexPath {
	NSDictionary* bookInfo = [bookList getMsgDataAt:indexPath];
    //NSLog(@"the book info:%@", bookInfo);
    KKBookInfoController* controller = [[KKBookInfoController alloc] initWithBookId:[bookInfo objectForKey:@"bookid"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) refreshAll {
	[self changeBookStatus:self.status];
}

-(void) filter {
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部", @"未读", @"在读", @"已读", nil];
    //[sheet showInView:self.view];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    [sheet release];
}

-(NSString *) getViewTitleWithStatus:(NSString *) _status {
    if ([_status isEqualToString:@"shelf"]) {
        return @"全部藏书";
    } else if ([_status isEqualToString:@"unread"]) {
        return @"未读藏书";
    } else if ([_status isEqualToString:@"read"]) {
        return @"已读藏书";
    } else if ([_status isEqualToString:@"reading"]) {
        return @"在读藏书";
    } else if ([_status isEqualToString:@"buylist"]) {
        return @"购书单";
    }
    return @"";
}

-(int) getBookNum:(NSString *) _status {
    NSDictionary* postData = [NSDictionary dictionaryWithObjectsAndKeys:@"dali", @"user_name",
                              @"dali", @"token", nil];
    NSString* url = [NSString stringWithFormat:@"http://192.168.0.104/index.php/mybook/booknum/%@/dali", _status];
	NSURLRequest* urlRequest = [[UtilModel getInstance]  generateRequesWithURL:url PostDictionary:postData];
	NSError* err = nil;
	NSURLResponse* response = nil;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&err];
	if (result == nil) {
		return -1;
	}
	XMLHelper* helper = [[XMLHelper alloc] init];
	NSDictionary* dict = [helper parseXML2Dictionary:result];
	[helper release];
	if (dict == nil) {
        return -1;
	}
	NSString* errorStr = [dict objectForKey:@"errno"];
	if (errorStr == nil) {
		return -1;
	}
	int error = [errorStr intValue];
	if (error != 0) {
		return -1;
	}
	
	if (![[dict objectForKey:@"detail"] isKindOfClass:[NSDictionary class]]) {
		return -1;
	} 
    NSDictionary* detail = [dict objectForKey:@"detail"];
    if ([detail objectForKey:@"num"] == nil) {
        return -1;
    }
    NSString* numStr = [detail objectForKey:@"num"];
    return [numStr intValue];
}

-(void) setBookNum:(NSDictionary *) bookNumInfo {
    //NSLog(@"The book num: %@", bookNumStr);
    NSString* _status = [bookNumInfo objectForKey:@"status"];
    NSString* bookNumStr = [bookNumInfo objectForKey:@"num"];
    if (_status == nil || bookNumStr == nil || ![_status isEqualToString:self.status]) {
        return ;
    }
    NSString* newTitle = nil;
    int bookNum = [bookNumStr intValue];
    if (bookNum <= 0) {
        newTitle = [self getViewTitleWithStatus:_status];
    } else {
        newTitle = [NSString stringWithFormat:@"%@(%d)", [self getViewTitleWithStatus:_status], bookNum];
    }
    [self setViewTitle:newTitle];
}

-(void) realUpdateBookNumForStatus:(NSString *) _status {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [_status retain];
    int bookNum = [self getBookNum:_status];
    //NSLog(@"The book num:%d", bookNum);
    NSString* bookNumStr = [NSString stringWithFormat:@"%d", bookNum];
    NSDictionary* bookNumInfo = [NSDictionary dictionaryWithObjectsAndKeys:_status, @"status", bookNumStr, @"num", nil];
    [self performSelectorOnMainThread:@selector(setBookNum:) withObject:bookNumInfo waitUntilDone:YES];
    [_status release];
    [pool release];
}

-(void) updateBookNumForStatus:(NSString *) _status { 
    //NSLog(@"the book num status:%@", _status);
    [NSThread detachNewThreadSelector:@selector(realUpdateBookNumForStatus:) toTarget:self withObject:_status];

}

-(void) changeBookStatus:(NSString *) _status {
    self.status = _status;
    [self setViewTitle:[self getViewTitleWithStatus:self.status]];
    NSString* url = nil;
    if ([self.status isEqualToString:@"buylist"] || [self.status isEqualToString:@"shelf"]) {
        url = [NSString stringWithFormat:@"http://192.168.0.104/index.php/mybook/%@/dali/", self.status];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.0.104/index.php/mybook/filter/%@/dali/", self.status];
    }
    [bookListView setURL:url];
    //NSLog(@"The url:%@", url);
    [bookListView cleanAll];
    [bookListView refresh];
    [self updateBookNumForStatus:_status];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self changeBookStatus:@"shelf"];
    } else if (buttonIndex == 1) {
        [self changeBookStatus:@"unread"];
    } else if (buttonIndex == 2) {
        [self changeBookStatus:@"reading"];
    } else if (buttonIndex == 3) {
        [self changeBookStatus:@"read"];
    }
}
@end
