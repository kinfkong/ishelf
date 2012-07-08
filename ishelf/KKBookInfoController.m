//
//  KKBookInfoController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKBookInfoController.h"
#import "UIImageView+ASYNC.h"

#import "UtilModel.h"
#import "KKTextController.h"


@implementation KKBookInfoController


@synthesize info;
@synthesize bookId;
@synthesize isbn;

-(id) initWithBookInfo:(NSDictionary *) _info {
    self = [super init];
    if (self) {
        //self.info = _info;
        self.info = [NSMutableDictionary  dictionaryWithDictionary:_info];
    }
    return self;
}

-(id) initWithBookId:(NSString *) _bookId {
    self = [super init];
    if (self) {
        //self.info = _info;
        self.info = nil;
        self.bookId = _bookId;
        self.isbn = nil;
    }
    return self;
}

-(id) initWithBookISBN:(NSString *) _isbn {
    self = [super init];
    if (self) {
        //self.info = _info;
        self.info = nil;
        self.isbn = _isbn;
        self.bookId = nil;
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
    [self.info release];
    [tableView release];
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
- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"书藉信息";
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:tableView];
    //[tableView release];
    
    if (self.info == nil && self.bookId != nil) {
        //NSLog(@"execute here");
        NSString* urlstr = [NSString stringWithFormat:@"http://192.168.0.104/index.php/mybook/get/%@/%@", self.bookId, @"dali"];
        //NSLog(@"the requested url:%@", urlstr);
        NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
        KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self tag:3456];
        [self.view addSubview:loadingView];
        [loadingView release];
        
        UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
        mask.backgroundColor = [UIColor whiteColor];
        mask.tag = 909;
        [tableView addSubview:mask];
        [mask release];

    } else if (self.info == nil && self.isbn != nil) {
        NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.104/index.php/isbn/index/%@/%@", self.isbn, @"dali"]]];
        KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self tag:3456];
        [self.view addSubview:loadingView];
        [loadingView release];
        
        UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
        mask.backgroundColor = [UIColor whiteColor];
        mask.tag = 909;
        [tableView addSubview:mask];
        [mask release];
    } else {
        [tableView reloadData];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        return 45;
    } else if ([indexPath row] == 1) {
        return 130;
    } else if ([indexPath row] == 2) {
        return 45;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath row] == 0) {
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 40)];
        title.textAlignment = UITextAlignmentCenter;
        // #2E8B57
        title.textColor = [UIColor colorWithRed:(2 * 16 + 14) / 256. green:(8 * 16 + 11) / 256. blue:(5 * 16 + 7) / 256. alpha:1.0];
        title.text = [self.info objectForKey:@"title"];
        title.font = [UIFont boldSystemFontOfSize:17];
        [cell addSubview:title];
        [title release];
    } else if ([indexPath row] == 1) {
        CGFloat imageWidth = 85;
        CGFloat imageHeight = 120;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, imageWidth, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

		NSString* url = [self.info objectForKey:@"image"];
        if (url == nil || [url isEqualToString:@""]) {
            imageView.image = [UIImage imageNamed:@"noimage.png"];
        } else {
             NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"id", indexPath, @"indexPath",nil];
            
            [imageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
        }
        
        [cell addSubview:imageView];
        [imageView release];
        
        UILabel* authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 310 - 110, 20)];
        [cell addSubview:authorLabel];
        authorLabel.textColor = [UIColor grayColor];
        authorLabel.font = [UIFont systemFontOfSize:14];
        authorLabel.text = [NSString stringWithFormat:@"作者: %@", [self.info objectForKey:@"author"]];
        [authorLabel release];
        
        
        UILabel* pubLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 25, 310 - 110, 20)];
        [cell addSubview:pubLabel];
        pubLabel.textColor = [UIColor grayColor];
        pubLabel.font = [UIFont systemFontOfSize:14];
        pubLabel.text = [NSString stringWithFormat:@"出版社: %@", [self.info objectForKey:@"publisher"] == nil ? @"无" : [self.info objectForKey:@"publisher"]];
        [pubLabel release];
        
        UILabel* pubdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 310 - 110, 20)];
        [cell addSubview:pubdateLabel];
        pubdateLabel.textColor = [UIColor grayColor];
        pubdateLabel.font = [UIFont systemFontOfSize:14];
        pubdateLabel.text = [NSString stringWithFormat:@"出版日期: %@", [self.info objectForKey:@"pubdate"] == nil ? @"无" : [self.info objectForKey:@"pubdate"]];
        [pubdateLabel release];
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 65, 310 - 110, 20)];
        [cell addSubview:priceLabel];
        priceLabel.textColor = [UIColor grayColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.text = [NSString stringWithFormat:@"定价: %@", [self.info objectForKey:@"price"]];
        [priceLabel release];
        
        UILabel* isbnLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 310 - 110, 20)];
        [cell addSubview:isbnLabel];
        isbnLabel.textColor = [UIColor grayColor];
        isbnLabel.font = [UIFont systemFontOfSize:14];
        isbnLabel.text = [NSString stringWithFormat:@"ISBN: %@", [self.info objectForKey:@"isbn"]];
        [isbnLabel release];
        
        UILabel* rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 105, 310 - 110, 20)];
        [cell addSubview:rateLabel];
        rateLabel.textColor = [UIColor grayColor];
        rateLabel.font = [UIFont systemFontOfSize:14];
        rateLabel.text = [NSString stringWithFormat:@"评分: %@分", [self.info objectForKey:@"rating"] == nil ? @"0" : [self.info objectForKey:@"rating"]];
        [rateLabel release];
    } else if ([indexPath row] == 2) {
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cell addSubview:button1];
        button1.frame = CGRectMake(30, 5, 120, 35);
        
        UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cell addSubview:button2];
        button2.frame = CGRectMake(290 - 120, 5, 120, 35);
        
        NSString* status = [self.info objectForKey:@"status"];
        if (status == nil || [status isEqualToString:@"none"]) {
            [button1 setTitle:@"加入藏经阁" forState:UIControlStateNormal];
            [button2 setTitle:@"加入购书单" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(addToShelf:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(addToBuylist:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if ([status isEqualToString:@"buylist"]) {
            [button1 setTitle:@"加入藏经阁" forState:UIControlStateNormal];
            [button2 setTitle:@"从购书单中删除" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(addToShelf:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(removeFromBuylist:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([status isEqualToString:@"unread"]) {
            [button1 setTitle:@"状态:未读" forState:UIControlStateNormal];
            [button2 setTitle:@"从藏经阁中删除" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(showPickUpView:) forControlEvents:UIControlEventTouchUpInside];
             [button2 addTarget:self action:@selector(removeFromShelf:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([status isEqualToString:@"reading"]) {
            [button1 setTitle:@"状态:在读" forState:UIControlStateNormal];
            [button2 setTitle:@"从藏经阁中删除" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(showPickUpView:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(removeFromShelf:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([status isEqualToString:@"read"]) {
            [button1 setTitle:@"状态:已读" forState:UIControlStateNormal];
            [button2 setTitle:@"从藏经阁中删除" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(showPickUpView:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(removeFromShelf:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if ([indexPath row] == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UILabel* summary = [[UILabel alloc] initWithFrame:CGRectMake((320 - 220) / 2., 2, 220, 35)];
        summary.text = @"内容简介";
        summary.textAlignment = UITextAlignmentCenter;
        [cell addSubview:summary];
        [summary release];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.textLabel.text = @"内容简介";
    } else if ([indexPath row] == 4) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UILabel* summary = [[UILabel alloc] initWithFrame:CGRectMake((320 - 220) / 2., 2, 220, 35)];
        summary.text = @"作者简介";
        summary.textAlignment = UITextAlignmentCenter;
        [cell addSubview:summary];
        [summary release];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([indexPath row] == 5) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UILabel* summary = [[UILabel alloc] initWithFrame:CGRectMake((320 - 220) / 2., 2, 220, 35)];
        summary.text = @"上豆瓣看看";
        summary.textAlignment = UITextAlignmentCenter;
        [cell addSubview:summary];
        [summary release];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 3) {
        KKTextController* controller = [[KKTextController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller setText:[self.info objectForKey:@"summary"]];
        [controller setTitle:@"内容简介"];
        [controller release];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([indexPath row] == 4) {
        KKTextController* controller = [[KKTextController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller setText:[self.info objectForKey:@"author_info"]];
        [controller setTitle:@"作者介绍"];
        [controller release];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([indexPath row] == 5) {
        NSString* urlstr = [self.info objectForKey:@"detail_url"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    } 
}

-(void) statusUpdate:(NSString *) status {
    UtilModel* utilModel = [UtilModel getInstance];
    NSMutableDictionary* modificationData = [[NSMutableDictionary alloc] init];
    [modificationData setObject:@"dali" forKey:@"token"];
    [modificationData setObject:[self.info objectForKey:@"id"] forKey:@"book"];
    [modificationData setObject:status forKey:@"status"];
    NSURLRequest* request = [utilModel generateRequesWithURL:@"http://192.168.0.104/index.php/mybook/updatestatus" 
											  PostDictionary:modificationData];
    
    KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
    [modificationData release];
}

-(void) addToShelf:(id) sender {
    [self statusUpdate:@"unread"];
}

-(void) addToBuylist:(id) sender {
    [self statusUpdate:@"buylist"];
}

-(void) removeFromBuylist:(id) sender {
    [self statusUpdate:@"none"];
}

-(void) removeFromShelf:(id) sender {
    [self statusUpdate:@"none"];
}

-(void) view:(KKNetworkLoadingView *) sender  onFailedLoading:(NSError *) error {
    //[readerView start];
    NSLog(@"failed ...");
}


-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
    //NSLog(@"the dict:%@", data);
    if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
        [self view:sender onFailedLoading:nil];
        return;
    }
    NSDictionary* detail = [data objectForKey:@"detail"];
    if (detail == nil || [detail objectForKey:@"status"] == nil) {
        [self view:sender onFailedLoading:nil];
    }
        //NSLog(@"before the dict:%@", detail);    
    if (sender.tag == 3456) {
        //NSLog(@"the dict:%@", detail);
        UIView* mask = [tableView viewWithTag:909];
        [mask removeFromSuperview];
        self.info = [[NSMutableDictionary alloc] initWithDictionary:detail];
    } else {
        [self.info setObject:[detail objectForKey:@"status"] forKey:@"status"];
        
        
        
    }
    //NSLog(@"%@", [self.info objectForKey:@"status"]);
    [tableView reloadData];
    
}

-(void) showPickUpView:(id) sender {
    NSString* spaceTitle = @"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:spaceTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    //[actionSheet showInView:self.view];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    UIPickerView* pickerView = [[[UIPickerView alloc] init] autorelease];
    pickerView.tag = 101;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [actionSheet addSubview:pickerView];
    
    NSInteger row = 0;
    NSString* status = [self.info objectForKey:@"status"];
    if ([status isEqualToString:@"unread"]) {
        row = 0;
    } else if ([status isEqualToString:@"read"]) {
        row = 2;
    } else if ([status isEqualToString:@"reading"]) {
        row = 1;
    }
    [pickerView selectRow:row inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"未读";
    } else if (row == 1) {
        return @"在读";
    } else if (row == 2) {
        return @"已读";
    }
    return @"";
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIPickerView* pickerView = (UIPickerView *) [actionSheet viewWithTag:101];
    NSInteger row = [pickerView selectedRowInComponent:0];
    if (row == 0) {
        [self statusUpdate:@"unread"];
    } else if (row == 1) {
        [self statusUpdate:@"reading"];
    } else if (row == 2) {
        [self statusUpdate:@"read"];
    }
    [actionSheet release];
}

@end
