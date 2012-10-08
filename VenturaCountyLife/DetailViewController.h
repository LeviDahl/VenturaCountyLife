//
//  DetailViewController.h
//  VenturaCountyLife
//
//  Created by LeviMac on 9/10/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString *detailid;
}
@property (nonatomic, retain) NSString *detailid;
@property (nonatomic, retain) IBOutlet UILabel *detailname;
@property (nonatomic, retain) IBOutlet UILabel *detaildesc;
@property (nonatomic, retain) IBOutlet UILabel *detaildate;
@property (nonatomic, retain) IBOutlet UILabel *detailtime;
@property (nonatomic, retain) IBOutlet UILabel *detailcost;
@property (nonatomic, retain) NSDictionary *extractedData;
@property (nonatomic, retain) NSArray *linedata;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@end
