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
#import "activeConnection.h"
#import "AppDelegate.h"
#import "AddConnectionViewController.h"
#import "ApplicationTableViewController.h"

@interface ChooseConnectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    AddConnectionViewController *addView;
    ApplicationTableViewController *applications;
    NSArray* applicationsData;
    activeConnection* CurrentConnection;
    
}


//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *applicationsData;
@property(nonatomic,retain) AddConnectionViewController *addView;
@property(nonatomic,retain) NSMutableData *appData;
@property(nonatomic,retain) activeConnection* CurrentConnection;

-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password;
-(BOOL)validateURL:(NSString*)url;
-(void)getApplicationList;

@end
