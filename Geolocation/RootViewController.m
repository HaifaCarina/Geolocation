//
//  RootViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

- (void) loadView {
    [super loadView];
    
    // Initialize category icons
    UIImage *foodIcon = [UIImage imageNamed:@"icon-food.png"];
    UIImage *shopIcon = [UIImage imageNamed:@"icon-shop.png"];
    UIImage *sightseeingIcon = [UIImage imageNamed:@"icon-sightseeing.png"];
    UIImage *barIcon = [UIImage imageNamed:@"icon-bar.png"];
    
    AllViewController *allViewController = [[AllViewController alloc]init];
    allViewController.title = @"All";
    UINavigationController *allNavController = [[UINavigationController alloc]initWithRootViewController:allViewController];
	allNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    FoodViewController *foodViewController = [[FoodViewController alloc]init];
    foodViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"Food" image:foodIcon tag:1]autorelease];
    UINavigationController *foodNavController = [[UINavigationController alloc]initWithRootViewController:foodViewController];
	foodNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    ShopViewController *shopViewController = [[ShopViewController alloc]init];
    shopViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"Shop" image:shopIcon tag:2]autorelease];
    
    SightseeingViewController *sightseeingViewController = [[SightseeingViewController alloc]init];
    sightseeingViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"Sightseeing" image:sightseeingIcon tag:3]autorelease];
    
    BarViewController *barViewController =[[BarViewController alloc]init];
    barViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"Bar" image:barIcon tag:4]autorelease];
    
    
    UITabBarController *atabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    atabBarController.viewControllers = [[[NSArray alloc] initWithObjects:allNavController, foodNavController, shopViewController, sightseeingViewController,barViewController, nil] autorelease];
    atabBarController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height); 
    atabBarController.delegate = self;
	[self.view addSubview: [atabBarController view]];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {  
    [viewController viewWillAppear:YES];
} 




@end
