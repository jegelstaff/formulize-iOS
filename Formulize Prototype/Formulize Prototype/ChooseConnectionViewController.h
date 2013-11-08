//
//  ChooseConnectionViewController.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"
#import "AddConnectionViewController.h"

@interface ChooseConnectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *stringfromurlTextField;
   // NSArray *connections;
    sqlite3 *formulizeDB;
    NSString *databasePath;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSString *str;

//@property (nonatomic, retain) NSMutableArray *connectionArray;

+ (id)retrieveData;
-(IBAction)getConnection:(id)sender;

@end
