//
//  KKMainTabController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKMainTabController.h"
#import "KKDefaultBookListController.h"
#import "KKBuyListController.h"
#import "KKSearchBookListController.h"
#import "KKLoginController.h"


@implementation KKMainTabController

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
    //[barController release];
    [scanController release];
    [scan release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    //barController = [[UITabBarController alloc] init];
	super.delegate = self;
	UINavigationController* shelf = [[UINavigationController alloc] init];
	// shelf.delegate = self;
	shelf.tabBarItem.title = @"藏经阁";
	shelf.tabBarItem.image = [UIImage imageNamed:@"shelf_logo.png"];
    
    //NSString* shelfURL = @"http://192.168.0.104/index.php/mybook/shelf/dali/";
    KKDefaultBookListController* shelfList = [[KKDefaultBookListController alloc] initWithStatus:@"shelf"];
    //shelfList.title = @"dali的藏经阁";
    [shelf pushViewController:shelfList animated:NO];
    
    UINavigationController* buyList = [[UINavigationController alloc] init];
	// shelf.delegate = self;
	buyList.tabBarItem.title = @"购书单";
	buyList.tabBarItem.image = [UIImage imageNamed:@"buy_logo.png"];
    
    NSString* buylistURL = @"http://192.168.0.104/index.php/mybook/buylist/dali/";
    KKBuyListController* buylist = [[KKBuyListController alloc] initWithBookURL:buylistURL];
    //buylist.title = @"dali的购书单";
    [buyList pushViewController:buylist animated:NO];
    [buylist release];
	
    scan = [[UINavigationController alloc] init];
    scanController = [[KKZBarController alloc] init];
    [scan pushViewController:scanController animated:NO];
	scan.delegate = self;
	scan.tabBarItem.title = @"扫描";
	scan.tabBarItem.image = [UIImage imageNamed:@"barcode_logo.png"];
    
    UINavigationController* search = [[UINavigationController alloc] init];
	// shelf.delegate = self;
	search.tabBarItem.title = @"搜索";
	search.tabBarItem.image = [UIImage imageNamed:@"search_logo.png"];
    KKSearchBookListController* searchController = [[KKSearchBookListController alloc] init];
    [search pushViewController:searchController animated:NO];
    [searchController release];
    
	//MsgTableController* msgTableController = [[MsgTableController alloc] init];
	//[shelf pushViewController:msgTableController animated:NO];
	
	UINavigationController* more = [[UINavigationController alloc] init];
    more.tabBarItem.title = @"更多";
    more.tabBarItem.image = [UIImage imageNamed:@"more_logo.png"];
    KKLoginController* loginController = [[KKLoginController alloc] init];
    [more pushViewController:loginController animated:NO];
    [loginController release];
	super.viewControllers = [NSArray arrayWithObjects:shelf, buyList, scan, search, more, nil];
	
	//self.view = barController.view;
	
    [shelf release];
    [search release];
    [buyList release];
    [more release];
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


- (void)tabBarController:(UITabBarController *)_tabBarController didSelectViewController:(UIViewController *)viewController {
    if (scan.topViewController != scanController) {
        return;
    }
    if (viewController == scan) {
        [scanController viewDidAppear:NO];
    } else {
        [scanController viewDidDisappear:NO];
    }
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController 
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewDidAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
