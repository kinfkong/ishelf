//
//  KKZBarController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKZBarController.h"
#import "KKBookInfoController.h"


@implementation KKZBarController

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
    [readerView release];
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
    self.navigationItem.title = @"扫描书藉条型码";
    ZBarImageScanner* scanner = [[ZBarImageScanner alloc] init];
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    readerView = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    readerView.readerDelegate = self;
    readerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [readerView setZoom:1.0 animated:YES];
    readerView.tracksSymbols = NO;
    [scanner release];
    
    [self.view addSubview:readerView];
    
    CGFloat lineWidth = 260;
    UIView* redLine = [[UIView alloc] initWithFrame:CGRectMake((320 - lineWidth) / 2, self.view.frame.size.height / 2, lineWidth, 1)];
    redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLine];
    [redLine release];
    
    
    UIView* upperMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 170) / 2)];
    upperMask.backgroundColor = [UIColor blackColor];
    upperMask.alpha = 0.6;
    [self.view addSubview:upperMask];
    [upperMask release];
    UIView* lowerMask = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (self.view.frame.size.height - 170) / 2, self.view.frame.size.width, (self.view.frame.size.height - 150) / 2)];
    lowerMask.backgroundColor = [UIColor blackColor];
    lowerMask.alpha = 0.6;
    [self.view addSubview:lowerMask];
    [lowerMask release];
    
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = UITextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"与条形码间距10cm左右，避免反光和阴影";
    tipLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipLabel];
    [readerView start];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
-(void) viewDidAppear:(BOOL)animated {
    [readerView start];
}

-(void) viewDidDisappear:(BOOL)animated {
    [readerView stop];
}

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

- (void) readerView: (ZBarReaderView*) _readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image {
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    [readerView stop];
    NSString* isbn = symbol.data;
    NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.104/index.php/isbn/index/%@/%@", isbn, @"dali"]]];
    KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
    
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
    if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
        [self view:sender onFailedLoading:nil];
        return;
    }
    KKBookInfoController* controller = [[KKBookInfoController alloc] initWithBookInfo:(NSDictionary *) [data objectForKey:@"detail"]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void) view:(KKNetworkLoadingView *) sender  onFailedLoading:(NSError *) error {
    [readerView start];
}


@end
