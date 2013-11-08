//
//  ViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

//@class AddConnectionViewController;
//@protocol AddConnectionDelegate <NSObject>

//-(void) passItemBack:(AddConnectionViewController *)controller didAddConnection:(NSString *)url;


@interface AddConnectionViewController : UIViewController <UITextFieldDelegate>
{
    sqlite3 *formulizeDB;
    NSString *databasePath;
    NSString *status;
}

@property (strong, nonatomic) IBOutlet UILabel *urlNameLabel;

@property (strong, nonatomic) IBOutlet UITextField *urlNameTextField;

@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

//@property (strong, nonatomic) IBOutlet UIButton * saveButton;

- (IBAction)onoffSwitch:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

- (IBAction)saveConnection:(id)sender;

-(IBAction)getConnection:(id)sender;
//@property (strong, nonatomic) id <AddConnectionDelegate> delegate;

@end
