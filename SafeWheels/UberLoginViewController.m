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
@property (strong, nonatomic) NSString* server_token;
@property (strong, nonatomic) NSString* uberProductId;

@end

@implementation UberLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)getProductId:(CLLocation*)startLocation
{
    [_uberKit getProductsForLocation:startLocation withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             _uberProductId = product.product_id;
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}



- (IBAction)makeRequest:(id)sender {
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:39.954693 longitude:-75.201137];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:39.962584 longitude:-75.1688];
    [self getProductId:startLocation];
    
    [self makeUberRequest:_uberProductId
                start_lat:(float)startLocation.coordinate.latitude
               start_long:(float)startLocation.coordinate.longitude
                  end_lat:(float)endLocation.coordinate.latitude
                 end_long:(float)endLocation.coordinate.longitude];
    
    
}


- (void) makeUberRequest:(NSString*) product_id start_lat:(float)start_lat start_long:(float)start_long end_lat:(float)end_lat end_long:(float)end_long
{

    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests?access_token=%@", _access_token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"This is the product id: %@", @"1a150e95-d687-454b-9878-2942a9448693");
    NSLog(@"This is the product id: %f", start_lat);
    NSLog(@"This is the product id: %f", start_long);
    
    NSDictionary* requestDictionary = @{@"product_id" : @"1a150e95-d687-454b-9878-2942a9448693",
                                        @"start_longitude" : [NSNumber numberWithFloat:start_long],
                                        @"start_latitude" : [NSNumber numberWithFloat:start_lat]
                                        };
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:nil]];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *authData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *authDictionary = [NSJSONSerialization JSONObjectWithData:authData options:0 error:&jsonError];
        if(!jsonError)
        {
            for(NSString *key in [authDictionary allKeys]) {
                NSLog(@"%@", key);
                NSLog(@"%@",[authDictionary objectForKey:key]);
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
