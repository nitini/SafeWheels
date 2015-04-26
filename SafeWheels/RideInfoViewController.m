//
//  RideInfoViewController.m
//  
//
//  Created by Nitin Iyer on 4/21/15.
//
//

#import "RideInfoViewController.h"



@interface RideInfoViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) UberCommands* uberController;
@property (weak, nonatomic) IBOutlet UILabel *carInfo;
@property (weak, nonatomic) IBOutlet UILabel *driverInfo;
@property (weak, nonatomic) IBOutlet UILabel *etaInfo;
@property (weak, nonatomic) IBOutlet UIImageView *carPicture;
@property (weak, nonatomic) IBOutlet UIImageView *driverPicture;
@property (strong, nonatomic) NSDictionary* requestDetails;
@end

@implementation RideInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _uberController = [UberCommands getInstance];
    _requestDetails = [_uberController getRequestDetails:_requestId];
    NSDictionary* driverDetails =[_requestDetails objectForKey:@"driver"];
    NSDictionary* vehicleDetails = [_requestDetails objectForKey:@"vehicle"];
    _etaInfo.text = [[_requestDetails objectForKey:@"eta"] stringValue];
    // Do any additional setup after loading the view.
    
    NSURL *driverURL = [NSURL URLWithString:[driverDetails objectForKey:@"picture_url"]];
    NSData *driverURLData = [NSData dataWithContentsOfURL:driverURL];
    _driverPicture.image = [[UIImage alloc] initWithData:driverURLData];
    _carInfo.text = [NSString stringWithFormat:@"A %@ %@", [vehicleDetails objectForKey:@"make"],
                [vehicleDetails objectForKey:@"model"]];
    
    NSURL *carURL = [NSURL URLWithString:[vehicleDetails objectForKey:@"picture_url"]];
    NSData *carURLData = [NSData dataWithContentsOfURL:carURL];
    _carPicture.image = [[UIImage alloc] initWithData:carURLData];
    _driverInfo.text = [NSString stringWithFormat:@"%@, %@", [driverDetails objectForKey:@"name"],
                        [driverDetails objectForKey:@"phone_number"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelRideButtonPressed:(id)sender {
    [self cancelRide];
}

- (void)cancelRide
{
    UIAlertView *confirmALert = [[UIAlertView alloc]
                                 initWithTitle:@"Cancel Ride"
                                 message:@"Are you sure you want to cancel this ride?"
                                 delegate:self cancelButtonTitle:@"Yes"
                                 otherButtonTitles:@"No", nil];
    
    // Display Alert Message
    [confirmALert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [_uberController cancelUberRequest:_requestId];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
