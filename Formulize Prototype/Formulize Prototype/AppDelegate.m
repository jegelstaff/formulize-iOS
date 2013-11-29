//
//  AppDelegate.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize connections;
@synthesize activeConnections;


//-----------------------------------------------------------
//
// didFinishLaunchingWithOptions
//
//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
    
    //active logins are disconnected after the app closes 
    activeConnections=[[NSMutableArray alloc] init];
    return YES;
    
}


//-----------------------------------------------------------
//
// - (void)createEditableCopyOfDatabaseIfNeeded
// If database does not exist, build a path to a database file
// and create an editable copy of the database
//
//
- (void)createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    // Get the documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Build the path to the database file
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"formulizeios.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"formulizeios.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }    
    
}

//-----------------------------------------------------------
//
// (void)initializeDatabase
// Retrieve connections data from database
// and save it into Array connections in appDelegate
//
//
- (void)initializeDatabase
{
    NSMutableArray *connectionsArray = [[NSMutableArray alloc] init];
    self.connections = connectionsArray;
    
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"formulizeios.db"];
    
    // Open the database.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all connections.
        const char *sql = "SELECT id FROM connections";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 0);
                
                Connection *cn = [[Connection alloc] initWithPrimaryKey:primaryKey database:database];
				
                [connections addObject:cn];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
}

//-----------------------------------------------------------
//
// logoutFromURL:(NSURL *)url
// request a logout from the server
//
//
- (void)logoutFromURL:(NSString *)url{
    
    NSURL *logout_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php?op=logout",url]];
    
    // Create logout request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: logout_url];
    
    //load logout request
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];

}

//-----------------------------------------------------------
//
// dismissAlert:(UIAlertView *)alertView
//Method to dismiss alert view
//
//
-(void)dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

//-----------------------------------------------------------------------
//
// connection delegate method
// didReceiveResponse
//
//
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSString * requestURL= [[[connection originalRequest] URL] description];
    
    if([requestURL hasSuffix:@"/user.php?op=logout"] ){
        
        requestURL=[requestURL stringByReplacingOccurrencesOfString:@"/user.php?op=logout" withString:@""];
        
        NSHTTPURLResponse *urlresponse = (NSHTTPURLResponse *) response;
        int statusCode = [urlresponse statusCode];
        if (statusCode == 200) {
            
            for (activeConnection* item in self.activeConnections){
                if([item.url isEqualToString:requestURL]){
                  //  @synchronized(activeConnections){
                        [activeConnections removeObject:item];
                    //}
                    NSLog(@"Successfully removed an active connection");
                    
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Logged out successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5f];
            
        }
        else{
            NSLog(@"ERROR logging out");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Your session has already expired" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        UINavigationController *myNavCon = (UINavigationController*)self.window.rootViewController ;
        [myNavCon popToRootViewControllerAnimated:YES];
    }
}

//-----------------------------------------------------------
//
// removeConnection:(Connection *)connection
// delete an item from the list of connections
//
//
-(void)removeConnection:(Connection *)connection {
    
    //Gets the index of the connection to be removed from the connections array
	NSUInteger index = [connections indexOfObject:connection];
    
    if (index == NSNotFound) return;
    
    [connection deleteFromDatabase];
    [connections removeObject:connection];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    activeConnections = nil;
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
