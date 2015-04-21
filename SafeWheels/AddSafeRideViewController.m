//
//  AddSafeRideViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/19/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "AddSafeRideViewController.h"
#import "SetPickupDropoffViewController.h"

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
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)unwindToAddSafeRide:(UIStoryboardSegue*)unwindSegue
{
    
}

@end
