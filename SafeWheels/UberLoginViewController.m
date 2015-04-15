//
//  UberLoginViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/13/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "UberLoginViewController.h"
#import <Parse/Parse.h>
#import "NXOAuth2.h"
#import "UberKit.h"

@interface UberLoginViewController () <UberKitDelegate>
@property(strong, nonatomic) UberKit* uberKit;
@property (strong, nonatomic) NSString* access_token;
@end

@implementation UberLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _uberKit = [[UberKit alloc] initWithClientID:@"oShtBtA4Lh44kNEsUsDl2cFavZkJsTfs"
                                        ClientSecret:@"31aEn8fh5iyBb8dGxXF8Jjjacr8V2h2yn0VrDPa3"
                                             RedirectURL:@"http://localhost"
                                         ApplicationName:@"SafeWheels_v1"];
    _uberKit.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)uberButtonClicked:(id)sender {
    [_uberKit startLogin];
}


- (IBAction)uberAPIClicked:(id)sender {
    [_uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberActivity *activity = [activities objectAtIndex:2];
             NSLog(@"Last trip distance %f", activity.distance);
            
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];}


- (void) uberKit: (UberKit *) uberKit didReceiveAccessToken: (NSString *) accessToken
{
    NSLog(@"Successfully got access token");
    _access_token = [_uberKit getStoredAuthToken];
}



- (void) uberKit: (UberKit *) uberKit loginFailedWithError: (NSError *) error
{
    NSLog(@"%@", error);
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
