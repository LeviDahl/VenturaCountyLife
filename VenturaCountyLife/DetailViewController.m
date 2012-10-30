//
//  DetailViewController.m
//  VenturaCountyLife
//
//  Created by LeviMac on 9/10/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "DetailViewController.h"
#import "MKNetworkKit/MKNetworkKit.h"
#import "SBJSON/SBJson.h"
#import "DetailCell.h"
#import "VenueArtistView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <iAd/iAd.h>
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailcost, detaildate, detaildesc, detailid, detailname, detailtime, extractedData, linedata, myTableView, detailimage, adView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    myTableView.tableFooterView = [UIView new];
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    CGRect adFrame = adView.frame;
    adFrame.origin.y = self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height-adView.frame.size.height;
    adView.frame = adFrame;
    [self.view addSubview:adView];
    [self reloadJSONData];
    

}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    adView.hidden = YES;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	adView.hidden = NO;
}
- (void)populateData {
    NSDictionary *data = [extractedData objectForKey:@"Event"];
   detailname.text = [data objectForKey:@"name"];
     self.navigationItem.title = @"Event Detail";
    detailtime.text = [NSString stringWithFormat:@"%@, %@",[data objectForKey:@"address"], [data objectForKey:@"city"]];
     NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[outputFormatter dateFromString:[data objectForKey:@"date"]];
     [outputFormatter setDateFormat:@"MMMM dd"];
    detaildesc.text = [outputFormatter stringFromDate:date];
    NSLog(@"%@test", [[extractedData objectForKey:@"Event"] objectForKey:@"name"]);
         [outputFormatter setDateFormat:@"hh:mm a"];
     detaildate.text = [outputFormatter stringFromDate:date];
    [detailimage setImageWithURL:[NSString stringWithFormat:@"http://www.venturacountylife.com/img/app/%@.jpg", [data objectForKey:@"id"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
    
[myTableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)reloadJSONData {
    
    
	// Do any additional setup after loading the view.
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"www.venturacountylife.com" customHeaderFields:nil];
    
    //request parameters
    //these would be your GET or POST variables
    NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys: nil];
    
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    MKNetworkOperation* op = [engine
                              operationWithPath:[NSString stringWithFormat:@"events/detailview/%@.json", detailid] params: params
                              httpMethod:@"GET" ssl:NO];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
        
        SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        if (error)
        {NSLog(@"error%@", error);}
        extractedData = [parsedData valueForKey:@"rests"];
        [self populateData];
      
        NSLog(@"data%@", extractedData);
    } onError:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = (DetailCell*)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
  NSArray *tabletext = [NSArray arrayWithObjects:@"More About This Event", @"More About This Artist", @"More About This Venue", nil];
    cell.maintext.text = [tabletext objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
   VenueArtistView *venue = [self.storyboard instantiateViewControllerWithIdentifier:@"detail2"];
    switch (indexPath.row) {
        case 0:
            if ([[[extractedData objectForKey:@"Event"] objectForKey:@"description"]length] == 0)
            {
                 venue.tableName = [[extractedData objectForKey:@"Event"] objectForKey:@"name"];
                venue.tableData = @"Sorry, there is no description for this event available at the moment.";
            }
            else
            {
                NSString *string = [[extractedData objectForKey:@"Event"] objectForKey:@"description"];
                string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                venue.tableData = [[extractedData objectForKey:@"Event"] objectForKey:@"description"];
                venue.tableName = [[extractedData objectForKey:@"Event"] objectForKey:@"name"];
            }
            break;
        case 1:
            if ([[extractedData objectForKey:@"Artist"] count] == 0)
                 {
                     venue.tableName = [[extractedData objectForKey:@"Event"] objectForKey:@"name"];
                     venue.tableData = @"Sorry, there is no information on this artist at the moment.";
                 }
                 else {
                 
                    venue.tableName =  [[[extractedData valueForKey:@"Artist"] valueForKey:@"artistname"] objectAtIndex:0];
                     venue.tableData = [[[extractedData valueForKey:@"Artist"] valueForKey:@"artistdesc"] objectAtIndex:0];

                 }
        case 2:
            if ([[extractedData objectForKey:@"Venue"] count] == 0)
            {
                venue.tableName = [[extractedData objectForKey:@"Event"] objectForKey:@"placename"];
                venue.tableData = @"Sorry, there is no information on this venue at the moment.";
            }
            else {
                
                venue.tableName =  [[[extractedData valueForKey:@"Venue"] valueForKey:@"venuename"] objectAtIndex:0];
                venue.tableData = [[[extractedData valueForKey:@"Venue"] valueForKey:@"venuedesc"] objectAtIndex:0];
            
            }

        }
    [self.navigationController pushViewController:venue animated:YES];
    
}
@end
