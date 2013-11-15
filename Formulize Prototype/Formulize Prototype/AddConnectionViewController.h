//
//  ViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppDelegate.h"



@interface AddConnectionViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *urlNameTextField;
    UITextField *urlTextField;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    sqlite3 *formulizeDB;
    NSString *databasePath;
}

@property (strong, nonatomic) IBOutlet UITextField *urlNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

//@property (strong, nonatomic) IBOutlet UIButton * saveButton;

- (IBAction)onoffSwitch:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

- (IBAction)saveConnection:(id)sender;

- (IBAction)clickLoginButton:(id)sender;


@end
