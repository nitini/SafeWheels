//
//  SafeRidesTableViewController.m
//  
//
//  Created by Nitin Iyer on 4/19/15.
//
//

#import "SafeRidesTableViewController.h"
#import "UberLoginViewController.h"
#import "Parse/Parse.h"
#import "NXOAuth2.h"
#import "UberKit.h"

@interface SafeRidesTableViewController () <UberKitDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) UberKit* uberKit;
@property (strong, nonatomic) NSString* perma_access_token;
@property (strong, nonatomic) NSString* server_token;

@end

@implementation SafeRidesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _perma_access_token = @"ey9MkOWb1k2aTIWnJGoLUpYSPjAX2c";
    _uberKit = [[UberKit alloc] initWithClientID:@"oShtBtA4Lh44kNEsUsDl2cFavZkJsTfs"
                                    ClientSecret:@"31aEn8fh5iyBb8dGxXF8Jjjacr8V2h2yn0VrDPa3"
                                     RedirectURL:@"http://localhost"
                                 ApplicationName:@"SafeWheels_v1"];
    
    _parentPassword = @"password";
    _uberKit.delegate = self;
    _server_token = @"2XO_nTpi3YijHxcW03iLsTB_8JyYP4dXD2Gb1xLw";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (IBAction)addRideButtonPressed:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter your password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString* entered_password = [[alertView textFieldAtIndex:0] text];
        if ([entered_password isEqualToString:_parentPassword]) {
            [self performSegueWithIdentifier:@"addRideSegue" sender:self];
        } else {
            UIAlertView* incorrectPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Wrong Password"
                                                   message:@" \n Please enter the correct password"
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
            [incorrectPasswordAlert show];
            [self performSelector:@selector(alertViewDelayedDismiss:) withObject:incorrectPasswordAlert afterDelay:1];
        }
    } else {
        [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

-(void) alertViewDelayedDismiss:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"addRideSegue"]) {
        
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
