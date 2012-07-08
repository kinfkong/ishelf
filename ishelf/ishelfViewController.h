//
//  ishelfViewController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-4.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "KKMainTabController.h"

@interface ishelfViewController : KKMainTabController <ZBarReaderDelegate> {
    IBOutlet UIButton* scanButton;
}

@property (nonatomic, retain) IBOutlet UIButton* scanButton;


-(IBAction) onScan:(id) sender;

@end
