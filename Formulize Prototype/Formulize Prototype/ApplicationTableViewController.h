//
//  ApplicationTableViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuLinksTableViewController.h"

@interface ApplicationTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *applicationsData;
@property (strong, nonatomic) NSArray *menuLinksForApp;

@end
