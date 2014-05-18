//
//  MasterViewController.h
//  PeerLoggingClient
//
//  Created by michelle cannon on 5/17/14.
//  Copyright (c) 2014 michelle cannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@class DetailViewController;


@interface MasterViewController : UITableViewController<MCBrowserViewControllerDelegate,MCSessionDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;
- (void)showBrowser:(id)sender;
- (void)insertNewObject:(NSString*)message;

@end

