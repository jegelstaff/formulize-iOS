//
//  LoginViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-24-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)okButton:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

@end
