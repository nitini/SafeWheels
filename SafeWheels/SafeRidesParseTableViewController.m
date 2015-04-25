//
//  SafeRidesParseTableViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 4/21/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "SafeRidesParseTableViewController.h"

@interface SafeRidesParseTableViewController () <UberKitDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) UberKit* uberKit;
@property (strong, nonatomic) NSString* perma_access_token;
@property (strong, nonatomic) NSString* server_token;
@property (strong, nonatomic) NSString* className;
@property (strong, nonatomic) NSIndexPath* deleteIndexPath;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) NSString* alertViewFunction;
@property (strong, nonatomic) UberCommands* uberController;
@end

@implementation SafeRidesParseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _parentPassword = @"password";
    _uberController = [UberCommands getInstance];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadObjects];
}


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.className = @"SafeRide";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"SafeRide"];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    /*
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    */
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"RideName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Drop Off Address: %@",
                                 [object objectForKey:@"DropoffAddress"]];
    
    return cell;
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.objects count];
}

*/


- (IBAction)addRideButtonPressed:(id)sender {
    _alertViewFunction = @"add";
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter your password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([_alertViewFunction isEqualToString:@"add"]) {
        
        if (buttonIndex == 1) {
            NSString* enteredPassword = [[alertView textFieldAtIndex:0] text];
            if ([enteredPassword isEqualToString:_parentPassword]) {
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
    } else if ([_alertViewFunction isEqualToString:@"delete"]) {
        if (buttonIndex == 1) {
            NSString* enteredPassword = [[alertView textFieldAtIndex:0] text];
            if ([enteredPassword isEqualToString:_parentPassword]) {
                PFObject *object = [self.objects objectAtIndex:[_deleteIndexPath row]];
                
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        
                        [self loadObjects];
                    }
                }];
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
    } else if ([_alertViewFunction isEqualToString:@"confirm"]) {
        if (buttonIndex == 1) {
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
        } else {
            [self performSegueWithIdentifier:@"showRideInfoSegue" sender:self];
            
        }
    }

}

-(void) alertViewDelayedDismiss:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _alertViewFunction = @"confirm";
    _selectedIndexPath = indexPath;
    UIAlertView *confirmALert = [[UIAlertView alloc]
                                 initWithTitle:@"Confirm Ride"
                                 message:@"Are you sure you would like to take this ride?"
                                 delegate:self cancelButtonTitle:@"Yes"
                                 otherButtonTitles:@"No", nil];
    
    // Display Alert Message
    [confirmALert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) deleteRideButtonClicked:(NSIndexPath*)deletePath
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter your password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        _deleteIndexPath = indexPath;
        _alertViewFunction = @"delete";
        [self deleteRideButtonClicked:_deleteIndexPath];
        

        /*
        PFObject *object = [self.objects objectAtIndex:[indexPath row]];

        
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [self loadObjects];
            }
        }];
         */
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - Uber API Calls






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showRideInfoSegue"]) {
        
        PFObject* ride = [self.objects objectAtIndex:[_selectedIndexPath row]];
        PFGeoPoint* startLocation = [ride objectForKey:@"PickupLocation"];
        PFGeoPoint* endLocation = [ride objectForKey:@"DropoffLocation"];
        NSString* uberProductId = [_uberController getUberProductIdAtLocation:[[CLLocation alloc]
                                                                               initWithLatitude:startLocation.latitude
                                                                               longitude:startLocation.longitude] uberType:@"uberX"];
        
        NSString* requestId = [_uberController makeUberRequest:uberProductId
                    start_lat:(float)startLocation.latitude
                   start_long:(float)startLocation.longitude
                      end_lat:(float)endLocation.latitude
                     end_long:(float)endLocation.longitude];
        NSLog(@"%@", requestId);
        
        RideInfoViewController* destController = [segue destinationViewController];
        destController.requestId = requestId;

        
    }
    
    
    
}


- (IBAction)unwindToSafeRidesTableViewController:(UIStoryboardSegue*)unwindSegue
{
    
}

@end
