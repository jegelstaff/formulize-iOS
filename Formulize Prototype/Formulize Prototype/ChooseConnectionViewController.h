//
//  ChooseConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "AppDelegate.h"
#import "AddConnectionViewController.h"
#import "ApplicationTableViewController.h"
#import "EditConnectionViewController.h"

@interface ChooseConnectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    ApplicationTableViewController *applications;
    NSArray *applicationsData;
    Connection *connect;
}

@property (strong, nonatomic) NSArray *applicationsData;
@property (strong, nonatomic) IBOutlet UIButton *Login;
@property BOOL isLoggedIn;
@property (nonatomic, retain) Connection *connect;

-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password;

@end
