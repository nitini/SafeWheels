//
//  SafeWheelsLoginViewController.m
//  SafeWheels
//
//  Created by Nitin Iyer on 5/6/15.
//  Copyright (c) 2015 Nitin Iyer. All rights reserved.
//

#import "SafeWheelsLoginViewController.h"

@interface SafeWheelsLoginViewController ()

@end

@implementation SafeWheelsLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextField setSecureTextEntry:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    if ([_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""]) {
        _passwordTextField.text = @"";
        _userNameTextField.text = @"";
        UIAlertView* emptyFieldAlert = [[UIAlertView alloc] initWithTitle:@"User Name or Password is Empty"
                                                                         message:@" \n Please enter both"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
        [emptyFieldAlert show];
        //[self performSelector:@selector(alertViewDelayedDismiss:) withObject:emptyFieldAlert afterDelay:1];
        
    } else {
        
    }
}

-(void) alertViewDelayedDismiss:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    
}

- (IBAction)signUpButtonPressed:(id)sender {
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
