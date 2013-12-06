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
    
    activeConnections=[[NSMutableArray alloc] init];
    
    //timer to keep sessions alive as long as the application is active
    // fires every 10 mins
    timerIntervalInSeconds= 30.0; 
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
- (void)logoutFromURL:(NSString *)url {
    
    NSURL *logout_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php?op=logout",url]];
    
    // Create logout request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: logout_url];
    
    //load logout request
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];

}

//-----------------------------------------------------------
// removeActiveConnection:(NSString *)url
// remove activeConnection
//
//
- (void)removeActiveConnection:(NSString *)url{
    @synchronized(activeConnections){
        for (activeConnection* item in self.activeConnections){
            if([item.url isEqualToString:url]){
                [activeConnections removeObject:item];
            }
        }
    }
}
//-----------------------------------------------------------
//
// dismissAlert:(UIAlertView *)alertView
// Method to dismiss alert view
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
        
        //case: logout is successful
        if (statusCode == 200) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Logged out successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5f];
            
        }
        //case: logout is failed
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Your session has already expired" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        // disconnect and pop bac to home view
        [self removeActiveConnection:requestURL];
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


//-----------------------------------------------------------
//
// keepSessionAlive:(NSTimer *)timer
// extend user's session
//
//
-(void)keepSessionAlive:(NSTimer *)timer{
    @synchronized(activeConnections){
        for (activeConnection* item in self.activeConnections){
            [self extendSession: item.url];
        }
    }
}


//-----------------------------------------------------------------------
//
// connection delegate methods
// didReceiveData
//
//
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString * requestURL = [[[connection originalRequest] URL] description];
    
    if([requestURL hasSuffix:@"/isUserLoggedIn.php"] ){
        
        requestURL=[requestURL stringByReplacingOccurrencesOfString:@"/isUserLoggedIn.php" withString:@""];
        
        NSString* urldata =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        // case: session has expired
        if([urldata isEqualToString:@"0"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session has Expired" 
                                                            message:@"Please sign in again" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self logoutFromURL:requestURL];
            
        }
        // else: (case: session still valid)       
    }
    
}


//-----------------------------------------------------------------------
//
// extendSession: (NSString *) url
// check if user has a valid session in URL
//
//
-(void)extendSession: (NSString *) url{
    
    // send a request to server to keep the session alive 
    NSString *extendSessionURLstr = [NSString stringWithFormat:@"%@/isUserLoggedIn.php",url];
    
    NSURL *extendSessionURL=[NSURL URLWithString:extendSessionURLstr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:extendSessionURL];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"ERROR checking Valid Login...");
    }
    
}

//-----------------------------------------------------------------------
//
// validateLogin:url :username :password
//
//
-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password{
    
    // gather login data
    NSString *login =@"login";
    NSString *postInfo =[[NSString alloc] initWithFormat:@"op=%@&pass=%@&uname=%@",login, password, username];
    
    NSURL *login_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php",url]];
    NSData *postData = [postInfo dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    
    // Create LOGIN request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:login_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"ERROR Logging in");
    }
    
}


//-----------------------------------------------------------------------
//
// (void)applicationWillResignActive:(UIApplication *)application
//
//
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     */
    
   //invalidate timer
    [timerCheckSessionStatus invalidate];
    timerCheckSessionStatus = nil;
    
    //save active connections
    NSMutableArray *saveActiveConnections = [[NSMutableArray alloc] init];
    NSArray *TempActiveConnections ;
    @synchronized(activeConnections){
        TempActiveConnections = [NSArray arrayWithArray:activeConnections];
    }    
    for (activeConnection* cn in TempActiveConnections){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:cn.pKey] forKey:@"pkey"];
        [dic setObject:cn.url forKey:@"url"];
        [dic setObject:cn.username forKey:@"username"];
        [dic setObject:cn.password forKey:@"password"];
         
        [saveActiveConnections addObject:dic];
    }
    TempActiveConnections = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:saveActiveConnections forKey:@"activeConnections"];
    [defaults synchronize];
    
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

//-----------------------------------------------------------------------
//
// (void)applicationDidBecomeActive:(UIApplication *)application
//
//
- (void)applicationDidBecomeActive:(UIApplication *)application
{
     //Restart any tasks that were paused (or not yet started) while the application was inactive.
    
    //get saved active connections
    
    NSArray *TempActiveConnections;
    NSMutableArray *getActiveConnections = [[NSMutableArray alloc] init];
    
    if([activeConnections count] == 0){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        TempActiveConnections =[defaults objectForKey:@"activeConnections"];
    
        for (NSDictionary* dic in TempActiveConnections){
            activeConnection *cn = [[activeConnection alloc] init];
            cn.pKey = [[dic objectForKey:@"pkey"] integerValue];
            cn.url = [dic objectForKey:@"url"];
            cn.username = [dic objectForKey:@"username"];
            cn.password = [dic objectForKey:@"password"];
            [getActiveConnections addObject:cn];
        }
    }
     TempActiveConnections = nil;
    
    //re-login any connections that were active before
    @synchronized(activeConnections){
        [activeConnections addObjectsFromArray:getActiveConnections];
        for (activeConnection* item in self.activeConnections){
            [self validateLogin: item.url :item.username :item.password];
        }
    }
    
    //re-validate timer to keep session alive
    timerCheckSessionStatus = [NSTimer scheduledTimerWithTimeInterval:timerIntervalInSeconds target:self selector:@selector(keepSessionAlive:) userInfo:nil repeats:YES];
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
