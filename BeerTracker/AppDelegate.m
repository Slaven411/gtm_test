//  AppDelegate.m
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "AppDelegate.h"
#import "ImageSaver.h"
#import "Mixpanel.h"
#import "TAGLogger.h"
#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGManager.h"

#define MIXPANEL_TOKEN @"ac10d9ad3d985270e72ce1ee02869453"

@interface AppDelegate ()<TAGContainerOpenerNotifier,TAGContainerCallback>
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window.tintColor = [UIColor whiteColor];
	[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.22f green:0.17f blue:0.13f alpha:1.00f]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    self.tagManager = [TAGManager instance];
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    [TAGContainerOpener openContainerWithId:@"GTM-P3T8VS"   // Update with your Container ID.
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:self];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(refreshContainer:)
                                   userInfo:nil
                                    repeats:YES];

    return YES;
}

- (void)refreshContainer:(NSTimer *)timer {
    
    [self.container refresh];
}

/**
 * Called before the refresh is about to begin.
 *
 * @param container The container being refreshed.
 * @param refreshType The type of refresh which is starting.
 */
- (void)containerRefreshBegin:(TAGContainer *)container
                  refreshType:(TAGContainerCallbackRefreshType)refreshType {
    // Notify UI that container refresh is beginning.
}


/**
 * Called when a refresh has successfully completed for the given refresh type.
 *
 * @param container The container being refreshed.
 * @param refreshType The type of refresh which completed successfully.
 */
- (void)containerRefreshSuccess:(TAGContainer *)container
                    refreshType:(TAGContainerCallbackRefreshType)refreshType {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContainerOpened" object:nil];
    });
}


/**
 * Called when a refresh has failed to complete for the given refresh type.
 *
 * @param container The container being refreshed.
 * @param failure The reason for the refresh failure.
 * @param refreshType The type of refresh which failed.
 */
- (void)containerRefreshFailure:(TAGContainer *)container
                        failure:(TAGContainerCallbackRefreshFailure)failure
                    refreshType:(TAGContainerCallbackRefreshType)refreshType {
    // Notify UI that container request has failed.
}

- (void)containerAvailable:(TAGContainer *)container {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContainerOpened" object:nil];
    });
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([self.tagManager previewWithUrl:url]) {
        return YES;
    }
    
    // Code to handle other urls.
    return NO;
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
