//
//  SetPickupDropoffViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/20/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "SetPickupDropoffViewController.h"
#import "AddSafeRideViewController.h"

@interface SetPickupDropoffViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *addressSearchBar;
@property (nonatomic, readwrite) CLLocationCoordinate2D addressLocation;
@property (strong, nonatomic) NSString* addressText;
@end

@implementation SetPickupDropoffViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:_addButtonText style:UIBarButtonItemStyleDone target:self action:@selector(setPickupLocation)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [_addressSearchBar setDelegate:self];
    self.pickupDropoffMap.frame = self.view.bounds;
    self.pickupDropoffMap.mapType = MKMapTypeHybrid;
    self.pickupDropoffMap.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            _pickupDropoffMap.showsUserLocation = YES;
        }
    }

    // Do any additional setup after loading the view.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _addressText = searchBar.text;
    [self addAnnotationAtAddress:_addressText];
}

-(void)setPickupLocation
{
    NSLog(@"Latitude: %f, Longitude: %f", _addressLocation.latitude, _addressLocation.longitude);
    [self performSegueWithIdentifier:@"unwindToAddSafeRide" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAnnotationAtAddress:(NSString*)address
{
    [self.pickupDropoffMap removeAnnotations:self.pickupDropoffMap.annotations];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 750, 750);
                         _addressLocation = placemark.coordinate;
                         [self.pickupDropoffMap setRegion:region animated:YES];
                         [self.pickupDropoffMap addAnnotation:placemark];
                     }
                 }
     ];
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 750, 750);
    [self.pickupDropoffMap setRegion:region animated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"unwindToAddSafeRide"]) {
        AddSafeRideViewController* addRideController = [segue destinationViewController];
        if (_pickup) {
            addRideController.pickupLocation = _addressLocation;
            addRideController.pickupAddress = _addressText;
        } else {
            addRideController.dropoffLocation = _addressLocation;
            addRideController.dropoffAddress = _addressText;
        }
    }
}


@end
