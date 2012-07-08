//
//  KKTextController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-11-13.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKTextController : UIViewController {
    UITextView* textView;
}

-(void) setText:(NSString *) text;
-(void) setTitle:(NSString *) title;

@end
