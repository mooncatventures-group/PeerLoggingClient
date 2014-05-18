//
//  MasterViewController.m
//  PeerLoggingClient
//
//  Created by michelle cannon on 5/17/14.
//  Copyright (c) 2014 michelle cannon. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@property (strong) MCBrowserViewController *browser;
@property (strong) MCAdvertiserAssistant *assistant;
@property (strong) MCSession *session;
@property (strong) MCPeerID *peerID;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	    UIBarButtonItem *browseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showBrowser:)];
    self.navigationItem.rightBarButtonItem = browseButton;
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showActionSheet:)];
    self.navigationItem.leftBarButtonItem = actionButton;

    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.title = @"Peer Logging Client";
    
    // configure the peerID and session
	_peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice]name]];
	_session = [[MCSession alloc] initWithPeer:_peerID];
	_session.delegate = self;
	
	// create the browser viewcontroller with a unique service name
	_browser = [[MCBrowserViewController alloc] initWithServiceType:@"MC-Peer" session:_session];
	_browser.delegate = self;
	_assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"MC-Peer" discoveryInfo:nil session:_session];
	// tell the assistant to start advertising our fabulous chat
	[_assistant start];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(NSString*)message
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:message atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    self.tableView.separatorColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSObject *object = _objects[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setHighlightedTextColor:[UIColor darkGrayColor]];
   
    
    
    cell.textLabel.text = [object description];
    return cell;

   }

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //For iPad users
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 8;
    }
    else{
        return 15;
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)showBrowser:(id)sender
{
	[self presentViewController:_browser animated:YES completion:nil];
}


- (void)clearAll:(id)sender
{
	[_objects removeAllObjects];
    [appDelegate createAppLog];
    NSLog(@"new log created");
    [self.tableView reloadData];
    
}

-(IBAction)showActionSheet:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Available actions" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Clear Console" otherButtonTitles:@"send Log", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
   }

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
         switch (buttonIndex) {
     case 0:
     [self clearAll:self];
     break;
     case 1:
     [self sendFileFromDocumentFolderViaEmail:self];
     break;
     }
    
}



- (IBAction)sendFileFromDocumentFolderViaEmail:(id) sender {
    
    
	// get date as a string
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd:MM:yyyy"];
	NSDate *now = [NSDate date];
	NSString* timeString = [dateFormat stringFromDate:now];
    
    
	//NSArray *array = [[NSArray alloc] initWithObjects:@"myemail@gmail.com", nil];
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"mail log to support"];
	[controller setMessageBody:@"console debug log" isHTML:NO];
    
    //ToDo add as many valid email address as needed */
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"youraddress.com",nil];
    [controller setToRecipients:toRecipients];
    
    
    
    // Get the documents folder
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    
	NSData* file = [NSData dataWithContentsOfFile:logPath];
	
	NSString* filename = [timeString stringByAppendingString:@"-log.txt"];
    
	[controller addAttachmentData:file mimeType:@"text/plain" fileName:filename];
    
	[self presentModalViewController:controller animated:YES];
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)updateMsg:(NSString *)msg fromPeer:(NSString *)peerName
{

    self.title = peerName;
    [self insertNewObject:msg];
    //[appDelegate writeToLog:msg];
    NSLog(@"%@:%@",peerName,msg);

}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	NSLog(@"received data");
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[self updateMsg:msg fromPeer:peerID.displayName];
	});
}



-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{


}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}

@end



