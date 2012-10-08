//
//  MapAnnotation.h
//  VenturaCountyLife
//
//  Created by LeviMac on 10/7/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *itemid;
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString *itemid;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;


@end
