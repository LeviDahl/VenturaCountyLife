//
//  AreaNib.m
//  VenturaCountyLife
//
//  Created by LeviMac on 9/3/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "AreaNib.h"
#import "MKNetworkKit/MKNetworkOperation.h"
#import "SBJSON/SBJson.h"
@interface AreaNib ()

@end

@implementation AreaNib
@synthesize tableCell, myTableView, extractedData;
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
    self.title = @"Event Areas";
    [self reloadJSONData];
    
      
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
                              operationWithPath:@"/events/maintitles.json" params: params
                              httpMethod:@"GET" ssl:NO];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
  
        SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        if (error)
        {NSLog(@"%@", error);}
    
        extractedData = [parsedData valueForKey:@"rests"];
         [myTableView reloadData];
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [extractedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    AreaTableCell *cell = (AreaTableCell*)[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    NSDictionary *eachevent = [[extractedData objectAtIndex:indexPath.row] objectForKey:@"Event"];
    NSString *eventname = [eachevent objectForKey:@"name"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[outputFormatter dateFromString:[eachevent objectForKey:@"date"]];
    NSLog(@"%@", date);
    NSLog(@"%@", eventname);
     [outputFormatter setDateFormat:@"MM-dd"];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.mainLabel.text = eventname;
    
    
    cell.secondLabel.text = [outputFormatter stringFromDate:date];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];

     DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    NSDictionary *eachevent = [[extractedData objectAtIndex:indexPath.row] objectForKey:@"Event"];
    detailViewController.detailid = [eachevent objectForKey:@"id" ];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}

@end
