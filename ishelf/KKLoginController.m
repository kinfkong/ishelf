//
//  KKLoginController.m
//  ishelf
//
//  Created by Wang Jinggang on 11-11-16.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "KKLoginController.h"
#import "KKAuthController.h"

#if !defined(SinaWeiBoSDKDemo_APPKey)
#define SinaWeiBoSDKDemo_APPKey @"2129486555"
#endif

#if !defined(SinaWeiBoSDKDemo_APPSecret)
#define SinaWeiBoSDKDemo_APPSecret @"064cfe722de3133f3355e29bf197c7b0"
#endif

@implementation KKLoginController

@synthesize weibo;

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
    [weibo release];
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
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, 200, 100);
    [button setTitle:@"login" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void) onLogin:(id) sender {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoSDKDemo_APPKey 
						   withAppSecret:SinaWeiBoSDKDemo_APPSecret];
	weibo.delegate = self;
	[weibo startAuthorize];
}

- (void)weiboDidLogin
{
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    NSLog(@"user_id:%@", weibo.userID);
}

- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
													   message:userCancelled?@"用户取消操作":[error description]  
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) openAuthPage:(NSString *) url {
    KKAuthController* controller = [[KKAuthController alloc] init];
    controller.url = url;
    [self presentModalViewController:controller animated:YES];
    [controller release];
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

@end
