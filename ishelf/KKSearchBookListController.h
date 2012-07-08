//
//  KKSearchBookListController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-11-12.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBookListView.h"


@interface KKSearchBookListController : UIViewController <KKBookListViewDelegate, UISearchBarDelegate> {
    UISearchBar* searchBar;
    KKBookListView* bookListView;
}

@end
