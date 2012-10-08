//
//  SecondViewController.h
//  VenturaCountyLife
//
//  Created by LeviMac on 8/29/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
@interface SecondViewController : UIViewController <TKCalendarMonthViewDataSource, TKCalendarMonthViewDelegate> {
    TKCalendarMonthView *calendar;
}
@property (nonatomic, retain) TKCalendarMonthView *calendar;
@end
