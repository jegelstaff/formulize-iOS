//
//  AppDelegate.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Connection.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *database;
    NSMutableArray *connections;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSMutableArray *connections;
@property (nonatomic, retain) NSMutableArray *activeConnections;

- (void)initializeDatabase;
- (void)removeConnection:(Connection *)connection;
//- (Todo *)addConnection:(Connection *)connection;

@end
