//
//  AddConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppDelegate.h"
#import "ChooseConnectionViewController.h"


@interface AddConnectionViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *urlNameTextField;
    UITextField *urlTextField;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UISwitch *rememberMe;
    sqlite3 *formulizeDB;
    NSString *databasePath;
}

@property (strong, nonatomic) IBOutlet UITextField *urlNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UISwitch *rememberMe;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onoffSwitch:(id)sender;

- (void)backgroundTouched;

- (IBAction)saveConnection:(id)sender;



@end
