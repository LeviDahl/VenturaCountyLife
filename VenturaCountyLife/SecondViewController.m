//
//  SecondViewController.m
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "SecondViewController.h"
#import "SBJSON/SBJson.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize calendar, dateTable, calendarbutton, sendDate, extractedData;
- (void)viewDidLoad
{
    [super viewDidLoad];
    calendar = [[TKCalendarMonthView alloc] initWithSundayAsFirst:true];
    calendar.delegate = self;
    calendar.dataSource = self;
    dateTable.alpha = 0.0;
    

	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:calendar];
    self.navigationItem.title = @"Calendar View";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.reload == true)
    {
        appDelegate.reload = false;
        [UIView animateWithDuration:0.3 animations:^() {
            dateTable.alpha = 0.0;
            calendar.alpha = 1.0;
            
        }];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


-(void)reloadJSONData {
    
    
	// Do any additional setup after loading the view.
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
     MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"www.venturacountylife.com" customHeaderFields:nil];
    
    //request parameters
    //these would be your GET or POST variables
    __block NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys: nil];
    
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    NSString *request = [NSString stringWithFormat:@"events/date/%@.json", sendDate];
    MKNetworkOperation* op = [engine
                              operationWithPath:request params: params
                              httpMethod:@"GET" ssl:NO];
      NSLog(@"request string = %@", request);
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
    
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
      
        __block SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        __block NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        if (error)
        {NSLog(@"error%@", error);}
        extractedData = nil;
        extractedData = [parsedData valueForKey:@"rests"];
        [dateTable reloadData];
        
       // NSLog(@"data%@", extractedData);
    } onError:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods
- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {
	NSLog(@"calendarMonthView marksFromDate toDate");
	NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
	NSArray *data = [NSArray arrayWithObjects: nil];
	
    
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
                                    fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
	
    
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// If the date is in the data array, add it to the marks array, else don't
		if ([data containsObject:[d description]]) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	return [NSArray arrayWithArray:marks];
}
- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {

    [UIView animateWithDuration:0.3 animations:^() {
        dateTable.alpha = 1.0;
        calendar.alpha = 0.0;
        
    }];
 //   self.navigationItem.rightBarButtonItem = calendarbutton;
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM-dd-yy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [outputFormatter setTimeZone:gmt];
    sendDate = [outputFormatter stringFromDate:d];
    NSLog(@"date = %@", sendDate);
    [outputFormatter setDateFormat:@"MMMM dd, yyyy"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:d]];
    [self reloadJSONData];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tabbar class = %@", tabBarController.class);
}
#pragma mark UITableView methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    [self.dateTable deselectRowAtIndexPath:[self.dateTable indexPathForSelectedRow] animated:YES];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    NSString *objectid = [[[extractedData valueForKey:@"Event"] valueForKey:@"id"]objectAtIndex:indexPath.row];
    detailViewController.detailid = objectid;
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[[extractedData valueForKey:@"Event"] valueForKey:@"name"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
       }
    if ([extractedData count] != 0)
    {
        cell.textLabel.text = [[[extractedData valueForKey:@"Event"] valueForKey:@"name"]objectAtIndex:indexPath.row];
        NSLog(@"single = %@", [[[extractedData valueForKey:@"Event"] valueForKey:@"name"]objectAtIndex:indexPath.row]);
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

   
    return cell;
}

@end
