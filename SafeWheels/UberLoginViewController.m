//
//  UberLoginViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/13/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "UberLoginViewController.h"
#import "Parse/Parse.h"
#import "ParseUI/ParseUI.h"
#import "NXOAuth2.h"
#import "UberKit.h"


@interface UberLoginViewController () <UberKitDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property(strong, nonatomic) UberKit* uberKit;
@property (strong, nonatomic) NSString* access_token;
@property (strong, nonatomic) NSString* server_token;
@property (strong, nonatomic) NSString* perma_access_token;
@property (strong, nonatomic) NSString* requestId;
@end

@implementation UberLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _perma_access_token = @"cNirl0W7g5zmAROEroBFLMbqeBpy6L";
    _uberKit = [[UberKit alloc] initWithClientID:@"oShtBtA4Lh44kNEsUsDl2cFavZkJsTfs"
                                        ClientSecret:@"31aEn8fh5iyBb8dGxXF8Jjjacr8V2h2yn0VrDPa3"
                                             RedirectURL:@"http://localhost"
                                         ApplicationName:@"SafeWheels_v1"];
    _uberKit.delegate = self;
    _server_token = @"2XO_nTpi3YijHxcW03iLsTB_8JyYP4dXD2Gb1xLw";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}



- (IBAction)uberButtonClicked:(id)sender {
    [_uberKit startLogin];
}

- (void) uberKit: (UberKit *) uberKit didReceiveAccessToken: (NSString *) accessToken
{
    _access_token = [_uberKit getStoredAuthToken];
    NSLog(@"%@", _access_token);
}

- (NSArray*)getUbersAvailableAtLocation:(CLLocation*)startLocation
{
    [_uberKit getProductsForLocation:startLocation withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    return @[@"1a150e95-d687-454b-9878-2942a9448693", @"UberXL", @"UberSUV", @"UberBlack"];
    
}



- (IBAction)makeRequest:(id)sender {
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:39.954693 longitude:-75.201137];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:39.962584 longitude:-75.1688];
    NSArray* ubersAvailable = [self getUbersAvailableAtLocation:startLocation];
    
    
    [self makeUberRequest:[ubersAvailable objectAtIndex:0]
                start_lat:(float)startLocation.coordinate.latitude
               start_long:(float)startLocation.coordinate.longitude
                  end_lat:(float)endLocation.coordinate.latitude
                 end_long:(float)endLocation.coordinate.longitude];
    
}


- (void) makeUberRequest:(NSString*) product_id start_lat:(float)start_lat start_long:(float)start_long end_lat:(float)end_lat end_long:(float)end_long
{

    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests?access_token=%@", _perma_access_token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* requestDictionary = @{@"product_id" :product_id,
                                        @"start_longitude" : [NSNumber numberWithFloat:start_long],
                                        @"start_latitude" : [NSNumber numberWithFloat:start_lat]
                                        };
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:nil]];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *requestData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *requestResultsDictionary = [NSJSONSerialization JSONObjectWithData:requestData options:0 error:&jsonError];
        if(!jsonError)
        {
            _requestId = [requestResultsDictionary objectForKey:@"request_id"];
            for(NSString *key in [requestResultsDictionary allKeys]) {
                NSLog(@"%@: %@", key,[requestResultsDictionary objectForKey:key]);
            }
        }
        else
        {
            NSLog(@"Error retrieving access token %@", jsonError);
        }
    }
    else
    {
        NSLog(@"Error in sending request for access token %@", error);
    }
}
- (IBAction)changeRequest:(id)sender {
    [self getRequestDetails];
}


- (void) getRequestDetails
{
    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests/%@",_requestId];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", _perma_access_token] forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *requestDetailsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *requestDetailsDictionary = [NSJSONSerialization JSONObjectWithData:requestDetailsData options:0 error:&jsonError];
        if(!jsonError)
        {
            for(NSString *key in [requestDetailsDictionary allKeys]) {
                NSLog(@"%@: %@", key,[requestDetailsDictionary objectForKey:key]);
            }
        }
        else
        {
            NSLog(@"Error retrieving access token %@", jsonError);
        }
    }
    else
    {
        NSLog(@"Error in sending request for access token %@", error);
    }
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
