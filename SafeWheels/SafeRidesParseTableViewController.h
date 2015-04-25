//
//  SafeRidesParseTableViewController.h
//  SafeWheels
//
//  Created by Nitin Iyer on 4/21/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "UberLoginViewController.h"
#import "Parse/Parse.h"
#import "NXOAuth2.h"
#import "UberKit.h"
#import "UberCommands.h"
#import "RideInfoViewController.h"

@interface SafeRidesParseTableViewController : PFQueryTableViewController

@property (strong, nonatomic) NSString* parentPassword;
@end
