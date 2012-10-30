//
//  VenueArtistView.h
//  VenturaCountyLife
//
//  Created by LeviMac on 10/9/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueArtistView : UIViewController {
    NSString *tableData;
    NSString *tableName;
}
@property (nonatomic, retain) NSString *tableData;
@property (nonatomic, retain) NSString *tableName;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@end
