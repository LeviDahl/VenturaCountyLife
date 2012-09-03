//
//  AreaNib.h
//  VenturaCountyLife
//
//  Created by LeviMac on 9/3/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTableCell.h"
@interface AreaNib : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@end
