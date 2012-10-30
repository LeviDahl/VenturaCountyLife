//
//  FirstViewController.h
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic, retain) NSDictionary *extractedData;
@property (nonatomic, retain) IBOutlet UITableView *searchtable;

@end
