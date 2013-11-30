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
#import "activeConnection.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *database;
    NSMutableArray *connections;
    NSTimer* timerCheckSessionStatus;
    float timerIntervalInSeconds;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *connections;
@property (nonatomic, retain) NSMutableArray *activeConnections;

- (void)initializeDatabase;
- (void)removeConnection:(Connection *)connection;

- (void)logoutFromURL:(NSString *)url;
- (void)extendSession: (NSString *) url;
- (void)keepSessionAlive:(NSTimer *)timer;
-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password;

@end
