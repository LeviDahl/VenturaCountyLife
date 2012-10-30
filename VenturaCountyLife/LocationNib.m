//
//  LocationNib.m
//  VenturaCountyLife
//
//  Created by LeviMac on 8/30/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "LocationNib.h"
#import "MapAnnotation.h"
#import "SBJSON/SBJson.h"
#import "DetailViewController.h"
@interface LocationNib ()

@end

@implementation LocationNib
BOOL firstRun;
@synthesize myMapView, dateButton, mypickerview, extractedData, toolbar;
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
	// Do any additional setup after loading the view.
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (myMapView.userLocation.location.horizontalAccuracy  < 10) {
        CLLocationCoordinate2D location;
        location.latitude = 34.2819;
        location.longitude  = -119.229864;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 60000.4672, 60000.4672);
        
        [myMapView setRegion:viewRegion animated:YES];
        firstRun = YES;
        [self reloadJSONData];
    }

}
- (void)viewDidAppear:(BOOL)animated
{
   
    if (firstRun == NO){
    if (myMapView.userLocation.location.horizontalAccuracy  < 10) {
        CLLocationCoordinate2D location;
        location.latitude = 34.2819;
        location.longitude  = -119.229864;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 60000.4672, 60000.4672);
        
        [myMapView setRegion:viewRegion animated:YES];
    
    }
    }
}
-(void)viewWillAppear:(BOOL)animated {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)populateData {
    
     NSDictionary *data = [extractedData valueForKey:@"Event"];
  for (int i = 0; i < [data count]; i++) {
           NSString *addressString = [NSString stringWithFormat:@"%@, %@", [[data valueForKey:@"address"] objectAtIndex:i] , [[data valueForKey:@"city"]objectAtIndex:i]];
      NSString *title = [[data valueForKey:@"name"]objectAtIndex:i];
      NSArray *array = [[NSArray alloc] initWithObjects:addressString, title, [[data valueForKey:@"id"]objectAtIndex:i], [[data valueForKey:@"placename"]objectAtIndex:i], nil];
    [self geocodeData:array];
    
               
                  
  }
   
   
   
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == myMapView.userLocation)
    {
        return nil;
    }
    else{
    static NSString *identifier = @"MapAnnotation";
    
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //here we use a nice image instead of the default pins
    }
    return annotationView;
    }
}


-(void) geocodeData:(NSArray*) array {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:[array objectAtIndex:0]
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:[array objectAtIndex:1] andCoordinate:placemark.location.coordinate];
                     newAnnotation.itemid = [array objectAtIndex:2];
                      newAnnotation.subtitle = [array objectAtIndex:3];
                     NSLog(@"%@id2", newAnnotation.itemid);
                     [myMapView addAnnotation:newAnnotation];
                     
                     dispatch_async(dispatch_get_main_queue(),^ {
                         NSLog(@"%@", placemarks);
                         if (placemarks.count == 0) {
                           
                             UIAlertView *alert = [[UIAlertView alloc] init] ;
                             alert.title = @"No places were found.";
                             [alert addButtonWithTitle:@"OK"];
                             [alert show];
                         }
                     });
                     
                 }];
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MapAnnotation *annotation = (MapAnnotation *)view.annotation;
    id itemid = annotation.itemid;
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detailViewController.detailid = itemid;
[self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)reloadJSONData {
    [mypickerview removeFromSuperview];
    [toolbar removeFromSuperview];
    for (id<MKAnnotation> annotation in myMapView.annotations) {
        [myMapView removeAnnotation:annotation];
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM-dd"];

     
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
    NSString *JSONUrl = [[NSString alloc] init];
    if (!firstRun ) {
   JSONUrl = [NSString stringWithFormat:@"events/mapviews/%@.json", [outputFormatter stringFromDate:mypickerview.date]];
        [outputFormatter setDateFormat:@"MMMM dd"];
        [dateButton setTitle:[outputFormatter stringFromDate:mypickerview.date] forState:UIControlStateNormal];

    }
    else{
         [outputFormatter setDateFormat:@"MM-dd"];
         JSONUrl = [NSString stringWithFormat:@"events/mapviews/%@.json", [outputFormatter stringFromDate:[NSDate date]]];
        [dateButton setTitle:@"Today" forState:UIControlStateNormal];
    }
    NSLog(@"date%@", JSONUrl);
    MKNetworkOperation* op = [engine
                              operationWithPath:JSONUrl params: params
                              httpMethod:@"GET" ssl:NO];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
        
        SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        if (error)
        {NSLog(@"error%@", error);}
        extractedData = [parsedData valueForKey:@"dates"];
        NSString *message = [[NSString alloc] init];
       if([extractedData count] == 0)
       {
           if (firstRun)
           {
               message = @"Sorry, no events for today. Please choose another date.";
           }
           else
           {
                message = @"Sorry, no events for this date. Please choose another date.";
           }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Events" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
               
       }
       else{
        [self populateData];
       }
        
    } onError:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

// tell the picker how many components it will have

  
-(IBAction)PickDate:(id)sender {
    mypickerview = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 195, 320, 200)];
    mypickerview.date = [NSDate date];
    mypickerview.datePickerMode = UIDatePickerModeDate;
    
   
    mypickerview.date = [NSDate date];
    
       firstRun = NO;
    [self.view addSubview:mypickerview];
     toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 151.0, 320.0, 44.0)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(reloadJSONData)];
    
    NSMutableArray* toolbarItems = [NSMutableArray array];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.tintColor = [UIColor darkGrayColor];
    [toolbar setTranslucent:YES];
    [toolbarItems addObject:flexibleSpaceLeft];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    [self.view addSubview:toolbar];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
