//
//  SetPickupDropoffViewController.h
//  SafeWheels
//
//  Created by Nitin Iyer on 4/20/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SetPickupDropoffViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *pickupDropoffMap;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString* addButtonText;
@property BOOL pickup;
@end
