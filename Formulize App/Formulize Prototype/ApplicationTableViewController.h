//
//  ApplicationTableViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuLinksTableViewController.h"
#import "AppDelegate.h"

@interface ApplicationTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *applicationsData;
    NSArray *menuLinksForApp;
    NSString *myURL;
}

@property (strong, nonatomic) NSArray *applicationsData;
@property (strong, nonatomic) NSArray *menuLinksForApp;
@property(nonatomic, strong, retain)  NSString *myURL;

- (IBAction) logout;

@end
