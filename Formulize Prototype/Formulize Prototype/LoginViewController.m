//
//  LoginViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-24-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize usernameLabel;
@synthesize usernameTextField;
@synthesize passwordLabel;
@synthesize passwordTextField;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [self setUsernameLabel:nil];
    [self setUsernameTextField:nil];
    [self setPasswordLabel:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}

- (IBAction)okButton:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTouched:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

@end
