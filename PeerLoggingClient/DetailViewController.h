//
//  DetailViewController.h
//  PeerLoggingClient
//
//  Created by michelle cannon on 5/17/14.
//  Copyright (c) 2014 michelle cannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
