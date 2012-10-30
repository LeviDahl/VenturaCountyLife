//
//  SecondViewController.h
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
@interface SecondViewController : UIViewController <TKCalendarMonthViewDataSource, TKCalendarMonthViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    TKCalendarMonthView *calendar;
}
@property (nonatomic, retain) IBOutlet UITableView *dateTable;
@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (nonatomic, retain) UIBarButtonItem *calendarbutton;
@property (nonatomic, retain) NSString *sendDate;
@property (nonatomic, retain) NSDictionary *extractedData;
@end
