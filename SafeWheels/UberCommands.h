//
//  UberCommands.h
//  
//
//  Created by Nitin Iyer on 4/25/15.
//
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "ParseUI/ParseUI.h"
#import "UberKit.h"


@interface UberCommands : NSObject <UberKitDelegate>

@property (strong, nonatomic) UberKit* uberKit;
@property (strong, nonatomic) NSString* serverToken;
@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* permaAccessToken;
+ (id) getInstance;
- (NSDictionary*) getRequestDetails:(NSString*)requestId;
-(NSString*) makeUberRequest:(NSString*) product_id start_lat:(float)start_lat
                  start_long:(float)start_long end_lat:(float)end_lat
                    end_long:(float)end_long;
- (NSString*) getUberProductIdAtLocation:(CLLocation*)startLocation uberType:(NSString*)uberType;
- (void) startUberLogin;
- (void) cancelUberRequest:(NSString*)requestId;


@end
