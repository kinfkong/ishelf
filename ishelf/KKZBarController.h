//
//  KKZBarController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "KKNetworkLoadingView.h"


@interface KKZBarController : UIViewController <ZBarReaderViewDelegate, KKNetworkLoadingViewDelegate> {
    // id <ZBarReaderDelegate> readerDelegate;
    ZBarReaderView *readerView;
}

@end
