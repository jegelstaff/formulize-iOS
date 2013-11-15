//
//  ChooseConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <sqlite3.h>
#import "Connection.h"
#import "AppDelegate.h"
#import "AddConnectionViewController.h"
#import "ApplicationTableViewController.h"

@interface ChooseConnectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    AddConnectionViewController *addView;
    ApplicationTableViewController *applications;
    NSArray *applicationsData;
    
}

//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *applicationsData;
@property (strong, nonatomic) IBOutlet UIButton *Login;
@property BOOL isLoggedIn;
@property(nonatomic,retain) AddConnectionViewController *addView;

-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password;

@end
