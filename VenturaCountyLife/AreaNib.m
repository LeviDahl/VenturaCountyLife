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
@synthesize tableCell, myTableView, extractedData, headerData, totalAreas;
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
    self.navigationController.tabBarItem.title = @"Areas";
    [self reloadJSONData];
    totalAreas = [[NSMutableArray alloc] init];

    
      
}
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width, 40)];
UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    [headerView addSubview:headerLabel];
    headerLabel.backgroundColor = [UIColor blueColor];
    headerLabel.textColor = [UIColor whiteColor];
       headerLabel.text = [headerData objectAtIndex:section];
    return headerView;
}
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
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
       NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString]];
        SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        if (error)
        {NSLog(@"%@", error);}
    
       extractedData = [parsedData valueForKey:@"rests"];
        headerData = [[extractedData valueForKey:@"Event"] valueForKeyPath:@"@distinctUnionOfObjects.placename"];
        NSArray *array = [extractedData valueForKey:@"Event"];
              for (int i = 0; i < [headerData count]; i++)
        {
        NSPredicate *bPredicate =
            [NSPredicate predicateWithFormat:@"placename == %@", [headerData objectAtIndex:i]];
        NSArray *beginWithB =
            [array filteredArrayUsingPredicate:bPredicate];
            
            __block NSDictionary *item = [NSDictionary dictionaryWithObject:beginWithB forKey:@"data"];
            [totalAreas addObject:item];
            
        }
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
    return [[[extractedData valueForKey:@"Event"] valueForKeyPath:@"@distinctUnionOfObjects.placename"] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [totalAreas objectAtIndex:section];
    
    NSArray *array = [dictionary objectForKey:@"data"];
    NSLog(@"arraycount%i", [array count]);
    return [array count];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    AreaTableCell *cell = (AreaTableCell*)[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dictionary = [totalAreas objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *areaname = [[array objectAtIndex:indexPath.row] valueForKey:@"name"];
    NSString *date = [[array objectAtIndex:indexPath.row] valueForKey:@"date"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dates =[outputFormatter dateFromString:date];
    [outputFormatter setDateFormat:@"MMMM dd"];
    cell.mainLabel.text = areaname;
    cell.secondLabel.text = [outputFormatter stringFromDate:dates];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
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
       NSDictionary *dictionary = [totalAreas objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *areaid = [[array objectAtIndex:indexPath.row] valueForKey:@"id"];
    detailViewController.detailid = areaid;
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
