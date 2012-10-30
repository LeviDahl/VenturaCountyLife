//
//  FirstViewController.m
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "FirstViewController.h"
#import "SBJSON/SBJson.h"
#import "DetailViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize mySearchBar, extractedData, searchtable;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search bar text = %@", mySearchBar.text);
    if([mySearchBar.text length] != 0)
       {
           [self reloadJSONData];
       }
}

-(void)reloadJSONData {
    
    
	// Do any additional setup after loading the view.
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    NSString *string = @"data[Events][search]";
    [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
              MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"www.venturacountylife.com" customHeaderFields:nil];
    
    //request parameters
    //these would be your GET or POST variables
    __block NSMutableDictionary* params = [NSMutableDictionary
                                           dictionaryWithObjectsAndKeys: nil];
    [params setObject:mySearchBar.text forKey:string];
    NSLog(@"text = %@", params);
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    NSString *request = [NSString stringWithFormat:@"events/search.json"];
    MKNetworkOperation* op = [engine
                              operationWithPath:request params: params
                              httpMethod:@"POST" ssl:NO];
    
    NSLog(@"request string = %@", op);
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSLog(@"response %@", [op responseString]);
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
    
        __block SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        __block NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        NSLog(@"parsed = %@", parsedData);
        if (error)
        {NSLog(@"error%@", error);}
        extractedData = nil;
        extractedData = [parsedData valueForKey:@"rests"];
        if  ([extractedData count] == 0)
        {
            NSLog(@"NO Data");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Search Results" message:@"Sorry, nothing in the database matches your search. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
            [mySearchBar resignFirstResponder];
        [searchtable reloadData];
        }
         NSLog(@"data%@", extractedData);
    } onError:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    [self.searchtable deselectRowAtIndexPath:[self.searchtable indexPathForSelectedRow] animated:YES];
    
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
    if ([[[extractedData valueForKey:@"Event"] valueForKey:@"name"] count] != 0)
    {
        cell.textLabel.text = [[[extractedData valueForKey:@"Event"] valueForKey:@"name"]objectAtIndex:indexPath.row];
        NSLog(@"single = %@", [[[extractedData valueForKey:@"Event"] valueForKey:@"name"]objectAtIndex:indexPath.row]);
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSLog(@"Data");
    }
       return cell;
}
@end
