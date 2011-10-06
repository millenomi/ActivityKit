//
//  ILAKAppDelegate.m
//  ActivityKitDemo
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILAKAppDelegate.h"

#import "ILAKViewController.h"
#import "Structure/ILSideViewController.h"

@interface ILAKAppDelegate () <ILSideViewControllerDelegate>
@end

@implementation ILAKAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIViewController* vc = [[ILAKViewController alloc] initWithNibName:@"ILAKViewController" bundle:nil];
    
    ILSideViewController* slider = [ILSideViewController new];
    slider.mainController = vc;
    slider.delegate = self;
    
    self.viewController = slider;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)drawerControllerForUserGestureInSideViewController:(ILSideViewController *)svc;
{
    UIViewController* vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIView* blueView = [[UIView alloc] initWithFrame:CGRectZero];
    blueView.backgroundColor = [UIColor blueColor];
    
    vc.view = blueView;

    return vc;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
