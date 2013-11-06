//
//  CLAppDelegate.m
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLAppDelegate.h"
#import "ListViewController.h"
//#import "CLServiceController.h"
#import "CLPageAppViewController.h"
#import "CLGallaryViewController.h"
#import "CLServiceViewController.h"



@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow * window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window =window;
    [window release];
    // Override point for customization after application launch.
    
    
    UITabBarController * tabBarController=[[UITabBarController alloc] init];
    
//----------------------
    ListViewController * listView=[[ListViewController alloc]init];
    UINavigationController * navigationControllerList=[[UINavigationController alloc] init];
    [navigationControllerList setViewControllers:[NSArray arrayWithObject:listView]];
//----------------------
    
    //CLGalleryController * galleryView=[[CLGalleryController alloc]init];
    CLServiceViewController * serviceView=[[CLServiceViewController alloc]init];
    CLGallaryViewController * galleryView=[[CLGallaryViewController alloc] init];
    [navigationControllerList.tabBarItem setTitle:@"List"];
    [navigationControllerList.tabBarItem setImage:[UIImage imageNamed:@"contact_card.png"]];
    [galleryView.tabBarItem setTitle:@"Gallery"];
    [galleryView.tabBarItem setImage:[UIImage imageNamed:@"picture.png"]];
    [serviceView.tabBarItem setTitle:@"Service"];
    [serviceView.tabBarItem setImage:[UIImage imageNamed:@"domain.png"]];
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:navigationControllerList,galleryView,serviceView, nil]];
    
    [self.window addSubview:tabBarController.view];
    [self.window setRootViewController:tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [listView release];
    [galleryView release];
    [serviceView release];
    [tabBarController release];
    [navigationControllerList release];
    return YES;
}

-(void) dealloc
{
    self.window=nil;
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
