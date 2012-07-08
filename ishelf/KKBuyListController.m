//
//  KKDefaultBookListController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-17.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKBuyListController.h"
#import "KKBookInfoController.h"


@implementation KKBuyListController

@synthesize url;

-(id) initWithBookURL:(NSString *)_url  {
    self = [super init];
    if (self != nil) {
        self.url = _url;
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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
    //self.title = @"test";
    //NSLog(@"here !!!");
	KKBookListView* bookListView = [[KKBookListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	bookListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bookListView.bookListDelegate = self;
	[bookListView setURL:self.url];
	
	[self.view addSubview:bookListView];
	[bookListView refresh];
    [bookListView release];
    
    self.navigationItem.title = @"购书单";
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


@end
