//
//  AddSafeRideViewController.h
//  SafeWheels
//
//  Created by Nitin Iyer on 4/19/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddSafeRideViewController : UIViewController
@property (nonatomic, readwrite) CLLocationCoordinate2D pickupLocation;
@property (nonatomic, readwrite) CLLocationCoordinate2D dropoffLocation;
@property (strong, nonatomic) NSString* pickupAddress;
@property (strong, nonatomic) NSString* dropoffAddress;
@property (weak, nonatomic) IBOutlet UITextField *pickupTextField;
@property (weak, nonatomic) IBOutlet UITextField *dropoffTextField;

@end
