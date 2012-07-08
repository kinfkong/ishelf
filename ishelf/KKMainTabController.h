//
//  KKMainTabController.h
//  ishelf
//
//  Created by Wang Jinggang on 11-9-5.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKZBarController.h"

@interface KKMainTabController : UITabBarController <UITabBarControllerDelegate,UINavigationControllerDelegate> {
    //UITabBarController* barController;
    UINavigationController* scan;
    KKZBarController* scanController;
}

@end
