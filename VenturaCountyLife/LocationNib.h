//
//  LocationNib.h
//  VenturaCountyLife
//
//  Created by LeviMac on 8/30/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
@interface LocationNib : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) UIDatePicker *mypickerview;
@property (nonatomic, retain) NSDictionary *extractedData;
@property (nonatomic, retain) NSString *datebutton;
@property (nonatomic, retain) UIToolbar *toolbar;


@end
