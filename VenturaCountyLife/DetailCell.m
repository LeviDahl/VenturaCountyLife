//
//  DetailCell.m
//  VenturaCountyLife
//
//  Created by LeviMac on 9/11/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell
@synthesize maintext;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
