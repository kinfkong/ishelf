//
//  KKBookInfoController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKNetworkLoadingView.h"


@interface KKBookInfoController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, KKNetworkLoadingViewDelegate> {
    NSMutableDictionary* info;
    UITableView* tableView;
    NSString* bookId;
    NSString* isbn;
}

@property (nonatomic, retain) NSMutableDictionary* info;
@property (nonatomic, retain) NSString* bookId;
@property (nonatomic, retain) NSString* isbn;

-(id) initWithBookInfo:(NSDictionary *) _info;

-(id) initWithBookId:(NSString *) _bookId;

-(id) initWithBookISBN:(NSString *) _isbn;

@end
