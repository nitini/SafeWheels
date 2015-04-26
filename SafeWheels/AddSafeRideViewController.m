//
//  AddSafeRideViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/19/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "AddSafeRideViewController.h"
#import "SetPickupDropoffViewController.h"
#import "SafeRidesParseTableViewController.h"

@interface AddSafeRideViewController ()
@property BOOL pickup;
@end

@implementation AddSafeRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickupAddress = @"";
    _dropoffAddress = @"";
    _pickupTextField.text = _pickupAddress;
    _dropoffTextField.text = _dropoffAddress;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    _pickupTextField.text = _pickupAddress;
    _dropoffTextField.text = _dropoffAddress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hitPickupButton:(id)sender {
    _pickup = YES;
    [self performSegueWithIdentifier:@"addRideSegue" sender:self];
}
- (IBAction)hitDropoffButton:(id)sender {
    _pickup = NO;
    [self performSegueWithIdentifier:@"addRideSegue" sender:self];
}

- (IBAction)hitCreateRideButton:(id)sender {
    if (![_rideNameTextField.text isEqualToString:@""]) {
         [self performSegueWithIdentifier:@"unwindToSafeRides" sender:self];
    } else {
        UIAlertView* incompleteFieldsAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete"
                                                                        message:@" \n Please fill all fields!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
        [incompleteFieldsAlert show];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addRideSegue"]) {
        SetPickupDropoffViewController* dest = [segue destinationViewController];
        if (_pickup) {
            dest.addButtonText = @"Set Pickup";
            dest.pickup = YES;
        } else {
            dest.addButtonText = @"Set Dropoff";
            dest.pickup = NO;
        }
    } else if ([segue.identifier isEqualToString:@"unwindToSafeRides"]) {
        PFObject *safeRide = [PFObject objectWithClassName:@"SafeRide"];
        NSString* textFieldString = _rideNameTextField.text;
        safeRide[@"RideName"] = textFieldString;
        textFieldString = _contactNumberTextField.text;
        safeRide[@"ContactNumber"] = textFieldString;
        textFieldString = _estimatedTimeTextField.text;
        safeRide[@"EstimatedTime"] = [NSNumber numberWithInt:[textFieldString intValue]];
        safeRide[@"PickupAddress"] = _pickupAddress;
        safeRide[@"DropoffAddress"] = _dropoffAddress;
        PFGeoPoint* pickup = [PFGeoPoint geoPointWithLatitude:_pickupLocation.latitude
                               longitude:_pickupLocation.longitude];
        safeRide[@"PickupLocation"] = pickup;
        PFGeoPoint* dropoff = [PFGeoPoint geoPointWithLatitude:_dropoffLocation.latitude
                                                    longitude:_dropoffLocation.longitude];
        safeRide[@"DropoffLocation"] = dropoff;
        PFUser* currentUser = [PFUser currentUser];
        NSString* userId = currentUser.objectId;
        safeRide[@"UserID"] = userId;
        
        [safeRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                NSLog(@"The error hit was: %@", error);
            }
        }];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)unwindToAddSafeRide:(UIStoryboardSegue*)unwindSegue
{
    
}

@end
