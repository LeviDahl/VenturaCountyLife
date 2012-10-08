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
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailcost, detaildate, detaildesc, detailid, detailname, detailtime, extractedData, linedata, myTableView;
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
    myTableView.tableFooterView.backgroundColor = [UIColor grayColor];

    [self reloadJSONData];
    

}
- (void)populateData {
    NSDictionary *data = [extractedData objectForKey:@"Event"];
   detailname.text = [data objectForKey:@"name"];
    self.title = @"Detail View";
   
    detailtime.text = [data objectForKey:@"address"];
     NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[outputFormatter dateFromString:[data objectForKey:@"date"]];
     [outputFormatter setDateFormat:@"MMMM-dd"];
    detaildesc.text = [outputFormatter stringFromDate:date];
    NSLog(@"%@test", [[extractedData objectForKey:@"Event"] objectForKey:@"name"]);
         [outputFormatter setDateFormat:@"hh:mm a"];
     detaildate.text = [outputFormatter stringFromDate:date];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = (DetailCell*)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
  NSArray *tabletext = [NSArray arrayWithObjects:@"More About This Event", @"More About This Artist", @"More About This Venue", @"Add This Event To Facebook", nil];
    cell.maintext.text = [tabletext objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    return 45;
}
@end
