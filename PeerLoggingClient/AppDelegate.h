//
//  AppDelegate.h
//  PeerLoggingClient
//
//  Created by michelle cannon on 5/17/14.
//  Copyright (c) 2014 michelle cannon. All rights reserved.
//  MIT licensed , free for commercial and non-comerical use.

/* the logging framework advertises as MC-Peer */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    int fd;
}

@property (strong, nonatomic) UIWindow *window;
-(void)closeLogFile;
-(void) writeToLog:(NSString*)message;
-(void) createAppLog;

@end
