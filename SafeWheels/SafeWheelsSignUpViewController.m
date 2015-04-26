//
//  SafeWheelsSignUpViewController.m
//  
//
//  Created by Nitin Iyer on 4/26/15.
//
//

#import "SafeWheelsSignUpViewController.h"

@interface SafeWheelsSignUpViewController ()

@end

@implementation SafeWheelsSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    [self.signUpView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    /*
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
     */
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
