//
//  FeaturedNib.m
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "AccountNib.h"
#import "SBJSON/SBJson.h"
#import "MembersArea.h"
@interface AccountNib ()

@end

@implementation AccountNib
@synthesize username, password, login;
NSString *URLString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)reloadJSONData {
    
    
	// Do any additional setup after loading the view.
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    NSDictionary *customheaders = [NSMutableDictionary dictionary];
    [customheaders setValue:@"iPhoneVCL" forKey:@"User-Agent"];
    MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"www.venturacountylife.com" customHeaderFields:customheaders];
    
    //request parameters
    //these would be your GET or POST variables
     NSMutableDictionary* params = [NSMutableDictionary
                                           dictionaryWithObjectsAndKeys:nil];
    [params setObject:username.text forKey:@"data[User][username]"];
    [params setObject:password.text forKey:@"data[User][password]"];
   
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    NSString *request = [NSString stringWithFormat:@"%@", URLString];
    MKNetworkOperation* op = [engine
                              operationWithPath:request params: params
                              httpMethod:@"POST" ssl:NO];
    NSLog(@"request string = %@", op);
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSString *responseData = [NSString stringWithFormat:@"%@",[op responseString] ];
       
        NSLog(@"response = %@",responseData);
        SBJsonParser *parser =  [[SBJsonParser alloc] init];
        NSError *error;
        NSDictionary *parsedData =  [parser objectWithString:responseData error:&error];
        NSLog(@"parsed = %@", parsedData);
        if (error)
        {NSLog(@"error%@", error);}
             NSString *response = [parsedData valueForKey:@"status"];

        
        if ([response isEqualToString:@"OK"])
            {
            MembersArea *members = [self.storyboard instantiateViewControllerWithIdentifier:@"members"];
                 [self.navigationController pushViewController:members animated:YES];
            }
        if ([response isEqualToString:@"Logged Out"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged In" message:@"You are Logged Out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([response isEqualToString:@"Not OK"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged In" message:@"Your username and/or password is incorrect. Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } onError:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}


-(IBAction)loginAction:(id)sender {
    [password resignFirstResponder];
    URLString = @"users/login";
    [self reloadJSONData];
    
}
-(IBAction)logoutAction:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
    URLString = @"users/logout";
    [self reloadJSONData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
    password.secureTextEntry = YES;
    URLString = @"users/login";
    [self reloadJSONData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
