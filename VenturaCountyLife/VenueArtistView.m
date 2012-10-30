//
//  VenueArtistView.m
//  VenturaCountyLife
//
//  Created by LeviMac on 10/9/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "VenueArtistView.h"
#import "GTMNSString+HTML.h"
@interface VenueArtistView ()

@end

@implementation VenueArtistView
@synthesize tableData,tableName, myTableView;
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
    self.title = @"Event Description";
   
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        cell.backgroundView = nil;
         if (indexPath.section == 0)
         {
        cell.textLabel.text = [tableName gtm_stringByUnescapingFromHTML];
         }
         else{
             cell.textLabel.text = [tableData gtm_stringByUnescapingFromHTML];;
         }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
 
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGSize constraint = CGSizeMake(320.0f - (15.0f * 2), 200000.0f);
    
    
   
  if (indexPath.section == 0)
  {
       CGSize labelSize = [tableName sizeWithFont:cellFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
      return labelSize.height + 30;
  }
  else{
    
       CGSize labelSize = [tableData sizeWithFont:cellFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
     return labelSize.height + 40;
      
  }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}
@end
