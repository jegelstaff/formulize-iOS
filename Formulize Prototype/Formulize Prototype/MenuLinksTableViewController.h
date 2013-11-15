//
//  MenuLinksTableViewController.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenWebViewController.h"

@interface MenuLinksTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *MenuLinksText;
@property (strong, nonatomic) NSString *menuLinkScreen;
@property (strong, nonatomic) NSString *menuLinkID;

@property (strong, nonatomic) IBOutlet UIButton *sendData;
@end
