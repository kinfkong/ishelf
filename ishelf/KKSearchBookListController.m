//
//  KKSearchBookListController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-11-12.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKSearchBookListController.h"
#import "KKBookListView.h"
#import "KKBookInfoController.h"


@implementation KKSearchBookListController

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
    [searchBar release];
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
	[self.view addSubview:searchBar];
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"输入书名、作者或ISBN";
	[searchBar becomeFirstResponder];
    
    bookListView = [[KKBookListView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
	bookListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bookListView.bookListDelegate = self; 
	//[bookListView setURL:self.url]; 
	
	[self.view addSubview:bookListView];
    //[bookListView release];

    
    self.navigationItem.title = @"搜索书籍";
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
    KKBookInfoController* controller = nil;
    if ([bookInfo objectForKey:@"bookid"] != nil) {
        controller = [[KKBookInfoController alloc] initWithBookId:[bookInfo objectForKey:@"bookid"]];
    } else {
        controller = [[KKBookInfoController alloc] initWithBookISBN:[bookInfo objectForKey:@"isbn"]];
    }
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar {
	[searchBar resignFirstResponder];
    
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)searchBar.text,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
	NSString* url = [NSString stringWithFormat:@"http://192.168.0.104/index.php/search/index/%@/", encodedString];
	[bookListView setURL:url];
	[bookListView cleanAll];
	[bookListView refresh];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) _searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

@end
