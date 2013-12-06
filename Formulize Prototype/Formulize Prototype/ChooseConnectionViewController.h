//
//  ChooseConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ApplicationTableViewController.h"
#import "EditConnectionViewController.h"

@interface ChooseConnectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    NSArray* applicationsData;
    Connection *connect;
}

@property (nonatomic, retain) NSArray *applicationsData;
@property(nonatomic,retain) NSMutableData *appData;
@property (nonatomic, retain) Connection *connect;
@property(nonatomic,retain) activeConnection* CurrentConnection;

-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password;
-(BOOL)validateURL:(NSString*)url;
-(void)hasValidSession:(NSString*)url;
-(void)getApplicationList:(NSString*)url;

@end
