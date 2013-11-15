//
//  ChooseConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <sqlite3.h>
#import "AddConnectionViewController.h"

@interface ChooseConnectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    AddConnectionViewController *addView;
}

//@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic,retain) AddConnectionViewController *addView;

@end
