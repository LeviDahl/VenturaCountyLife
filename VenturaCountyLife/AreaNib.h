//
//  AreaNib.h
//  VenturaCountyLife
//
//  Created by LeviMac on 9/3/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTableCell.h"
#import "DetailViewController.h"
@interface AreaNib : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray *extractedData;
@property (nonatomic, retain) NSArray *headerData;
@property (nonatomic, retain) NSMutableArray *totalAreas;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
-(void)reloadJSONData;
@end
