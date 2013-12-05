//
//  EditConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 11-21-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Connection.h"
#import "ChooseConnectionViewController.h"

@interface EditConnectionViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *urlNameTextField;
    UITextField *urlTextField;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UISwitch *rememberMe;
    Connection *connect;
    sqlite3 *formulizeDB;
    NSString *databasePath;
}

@property (strong, nonatomic) IBOutlet UITextField *urlNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField; 

@property (strong, nonatomic) IBOutlet UISwitch *rememberMe;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) Connection *connect;

- (IBAction)onoffSwitch:(id)sender;

- (IBAction)updateConnection:(id)sender;

-(void)updateConnectionInDatabase:(id)sender;

@end
