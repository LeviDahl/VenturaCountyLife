//
//  MapAnnotation.m
//  VenturaCountyLife
//
//  Created by LeviMac on 10/7/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title, coordinate, itemid, subtitle;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	title = ttl;
	coordinate = c2d;
	return self;
}

@end
