//
//  UberCommands.m
//  
//
//  Created by Nitin Iyer on 4/25/15.
//
//

#import "UberCommands.h"

@implementation UberCommands

- (id)init {
    if (self = [super init]) {
        _clientId = @"oShtBtA4Lh44kNEsUsDl2cFavZkJsTfs";
        _clientSecret = @"31aEn8fh5iyBb8dGxXF8Jjjacr8V2h2yn0VrDPa3";
        _serverToken = @"2XO_nTpi3YijHxcW03iLsTB_8JyYP4dXD2Gb1xLw";
        _permaAccessToken = @"iQAJqusGQmSoHTiaIvcDfcMDYpgQyf";

        _uberKit = [[UberKit alloc] initWithClientID:self.clientId
                             ClientSecret:self.clientSecret
                              RedirectURL:@"http://localhost"
                          ApplicationName:@"SafeWheels_v1"];
        _uberKit.delegate = self;
    }
    return self;
}

+ (id)getInstance {
    static UberCommands* uberController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uberController = [[self alloc] init];
    });
    return uberController;
}

- (void) startUberLogin
{
    [_uberKit startLogin];
}

-(NSString*) makeUberRequest:(NSString*) product_id start_lat:(float)start_lat start_long:(float)start_long end_lat:(float)end_lat end_long:(float)end_long
{
    
    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests?access_token=%@", _permaAccessToken];
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
    NSString* requestId = @"";
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *requestResultsDictionary = [NSJSONSerialization JSONObjectWithData:requestData options:0 error:&jsonError];
        if(!jsonError)
        {
            requestId = [requestResultsDictionary objectForKey:@"request_id"];
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
    return requestId;
}


- (NSDictionary*) getRequestDetails:(NSString*)requestId
{
    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests/%@",requestId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    //In reality _accessToken would be used here, but for now , use _permaAccessToken for testing purposes
    [request setValue:[NSString stringWithFormat:@"Bearer %@", _permaAccessToken] forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *requestDetailsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *requestDetailsDictionary = [NSJSONSerialization JSONObjectWithData:requestDetailsData options:0 error:&jsonError];
        NSLog(@"Request Details Dictionary %@", requestDetailsDictionary);
        return requestDetailsDictionary;
    }
    else
    {
        NSLog(@"Error in getting Request Details %@", error);
        return [[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"JSON not receieved", nil];
    }
}

- (void) changeUberRequestStatus:(NSString*)requestId status:(NSString*)status
{
    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/sandbox/requests/%@",requestId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", _permaAccessToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* statusDictionary = @{@"status": status};
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:statusDictionary options:NSJSONWritingPrettyPrinted error:nil]];
    
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *statusData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *statusResultsDictionary = [NSJSONSerialization JSONObjectWithData:statusData options:0 error:&jsonError];
        NSLog(@"Status Dictionary %@", statusResultsDictionary);
    }
    else
    {
        NSLog(@"Error in changing Uber Status %@", error);
    }
}

- (void) cancelUberRequest:(NSString*)requestId
{
    NSString *url = [NSString stringWithFormat:@"https://sandbox-api.uber.com/v1/requests/%@",requestId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", _permaAccessToken] forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

- (NSString*) getUberProductIdAtLocation:(CLLocation*)startLocation uberType:(NSString*)uberType
{
    NSString *url = [NSString stringWithFormat:@"https://api.uber.com/v1/products?server_token=%@&latitude=%f&longitude=%f",
                     _serverToken, startLocation.coordinate.latitude,
                     startLocation.coordinate.longitude];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSString* uberProductId = @"";
    NSData *productsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *productsDictionary = [NSJSONSerialization JSONObjectWithData:productsData options:0 error:&jsonError];
        if(!jsonError)
        {
            NSArray *products = [productsDictionary objectForKey:@"products"];
            for(int i=0; i<products.count; i++)
            {
                UberProduct *product = [[UberProduct alloc] initWithDictionary:[products objectAtIndex:i]];
                if ([product.display_name isEqualToString:uberType]) {
                    uberProductId = product.product_id;
                }
            }
        }
        else
        {
            NSLog(@"Error retrieving access token %@", jsonError);
        }
    }
    return uberProductId;
}

- (void) uberKit: (UberKit *) uberKit didReceiveAccessToken: (NSString *) accessToken
{
    _accessToken = [_uberKit getStoredAuthToken];
    NSLog(@"Access Token: %@", _accessToken);
}


- (void) uberKit: (UberKit *) uberKit loginFailedWithError: (NSError *) error
{
    NSLog(@"%@", error);
}








@end
