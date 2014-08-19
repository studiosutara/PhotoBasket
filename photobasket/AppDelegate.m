//
//  AppDelegate.m
//  photobasket
//
//  Created by Shilpa Modi on 10/25/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoViewerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "basketImage.h"
#import "SplashViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SplashViewController* splash = [[SplashViewController alloc] init];
    
    mView = [[TrialViewController alloc] init];
    [self.window setRootViewController:mView];

    [self getPhotos];
    return YES;
}

-(void) getPhotos
{
    mView.mPhotoURLs = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString* url = @"https://picasaweb.google.com/data/feed/api/all?q=nature&max-results=400&alt=json";
    NSLog(@"URL %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* feed = responseObject[@"feed"];
         
         NSArray* entry = feed[@"entry"];
         
         for (NSDictionary* anEntry in entry)
         {
             NSDictionary* mediaGroup = anEntry[@"media$group"];
             NSArray* mediaContent = mediaGroup[@"media$content"];
             NSDictionary* firstContent = mediaContent[0];
             NSString* PhotoUrl = firstContent[@"url"];
             uint height = [firstContent[@"height"] integerValue];
             uint width = [firstContent[@"width"] integerValue];
             basketImage* basket = [basketImage imageWith:PhotoUrl
                                                   height:height
                                                    width:width];
             
             NSArray* thumbnails = mediaGroup[@"media$thumbnail"];
             basket.mThumbnails = [[NSMutableArray alloc] init];
             for (NSDictionary* aThumbnail in thumbnails) {
                 basketImage* thumb = [basketImage imageWith:aThumbnail[@"url"]
                                                      height:[aThumbnail[@"height"] integerValue]
                                                       width:[aThumbnail[@"width"] integerValue]];
                 [basket.mThumbnails addObject:thumb];
             }
             
             [mView.mPhotoURLs addObject:basket];
             
         }
         
         [mView start];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}



//- (BOOL)application: (UIApplication *)application
//            openURL: (NSURL *)url
//  sourceApplication: (NSString *)sourceApplication
//         annotation: (id)annotation {
//    return [GPPURLHandler handleURL:url
//                  sourceApplication:sourceApplication
//                         annotation:annotation];
//}

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
