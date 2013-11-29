//
//  MenuLinksTableViewController.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenWebViewController.h"
#import "AppDelegate.h"

@interface MenuLinksTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *MenuLinksText;
@property(nonatomic, strong, retain)  NSDictionary *menuLink;
@property(nonatomic, strong, retain)  NSString *myURL;

- (IBAction) logout;

@end
