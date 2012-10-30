//
//  AppDelegate.h
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    UITabBarController *tabBarController;
    BOOL reload;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, assign) BOOL reload;
@end
