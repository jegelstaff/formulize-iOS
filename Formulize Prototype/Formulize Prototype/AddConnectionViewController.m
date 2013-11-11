//
//  ViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "AddConnectionViewController.h"
#import "AppDelegate.h"
#import <Foundation/NSJSONSerialization.h>

@implementation AddConnectionViewController
@synthesize urlNameLabel;
@synthesize urlNameTextField;
@synthesize urlLabel;
@synthesize urlTextField;
@synthesize usernameLabel;
@synthesize usernameTextField;
@synthesize passwordLabel;
@synthesize passwordTextField;

@synthesize loginButton;//test button


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
NSLog(@"Load");
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
       NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] 
    initWithString: [docsDir stringByAppendingPathComponent: 
@"Formulize.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        NSLog(@"db does not exist");
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
        {
            //NSLog(@"creating table");
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ConnectionEntry (ID INTEGER PRIMARY KEY AUTOINCREMENT, ConnectionName TEXT, ConnectionURL TEXT, Username TEXT, Password TEXT)";
            
            if (sqlite3_exec(formulizeDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status = @"Failed to create table";
                //NSLog(status);
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(formulizeDB);
            
        } else {
            status = @"Failed to open/create database";
            NSLog(@"Failed to open/create database");
        }
    }
 
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    
    [self setUrlLabel:nil];
    [self setUrlTextField:nil];
    [self setUsernameLabel:nil];
    [self setUsernameTextField:nil];
    [self setPasswordLabel:nil];
    [self setPasswordTextField:nil];
    [self setUrlNameLabel:nil];
    [self setUrlNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onoffSwitch:(id)sender {
}

- (IBAction)backgroundTouched:(id)sender {
    [urlTextField resignFirstResponder];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (IBAction)saveConnection:(id)sender {
    
    NSString *errorMsg= @"Please enter the ";
    Boolean IsInfoComplete;
    
    if([urlTextField.text isEqualToString:@""] || [usernameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""]){
        IsInfoComplete = false;
        if([urlTextField.text isEqualToString:@""]){
            NSLog(@"urlTextField is empty" );
            errorMsg= [errorMsg stringByAppendingString:@"URL"] ;
        }
        if([usernameTextField.text isEqualToString:@""]){
            NSLog(@"usernameTextField is empty" );
            errorMsg= [errorMsg stringByAppendingString:@" username"] ;
            
        }
        if([passwordTextField.text isEqualToString:@""]){
            NSLog(@"passwordTextField is empty" );
            errorMsg= [errorMsg stringByAppendingString:@" password"];
        }    
    }
    else{
        IsInfoComplete = true;
    }
    
    if (!IsInfoComplete){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required information is missing" 
                                                        message:errorMsg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        NSLog(@"Save connection");
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ConnectionEntry (ConnectionName, ConnectionURL, Username, Password)VALUES(\"%@\",\"%@\",\"%@\", \"%@\")",
              urlNameTextField.text, urlTextField.text, usernameTextField.text, passwordTextField.text];
              const char *insert_stmt = [insertSQL UTF8String];
              sqlite3_prepare_v2(formulizeDB, insert_stmt, 
             -1, &statement, NULL);
              if (sqlite3_step(statement) == SQLITE_DONE)
              {
                  status = @"Connection added";
                  NSLog(status);
                  NSLog(@"Connection added");
                  urlNameTextField.text = @"";
                  urlTextField.text = @"";
                  usernameTextField.text = @"";
                  passwordTextField.text = @"";
              } else {
                  status= @"Failed to add connnection";
                  NSLog(@"Failed to add connnection");
              }
              sqlite3_finalize(statement);
              sqlite3_close(formulizeDB);
          }
        
        //call retrieve data method
        [self getConnection:nil];
        
         
       [self.navigationController popToRootViewControllerAnimated:YES]; 
    }
 
}
//end of save connection        


- (IBAction)getConnection:(id)sender {
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: 
                              @"SELECT ConnectionName FROM ConnectionEntry"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(formulizeDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                NSString *connetionName = [[NSString alloc] 
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(
                                                                              statement, 0)];
                
                
                NSMutableArray *connectionArray = [[NSMutableArray alloc] init];
                appDelegate.connections = connectionArray;
                
                //[connectionArray nil];
                
                //      connectionArray = [[NSMutableArray alloc] init];
                //     [connectionArray addObject:connetionName];
                
                NSLog(@"Connection name retrieved: %@", connetionName);
            }
            NSLog(@"Connections Array3: %@",appDelegate.connections);
            
        } else {
            
            NSLog(@"Connection name could not be retrieved"); 
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(formulizeDB);
    
}//end of get connection  

- (IBAction)clickLoginButton:(id)sender{
    
	//get data for LOGIN request 
    
    //get data from database
    BOOL loggedIn = false;
    NSString *Uname =usernameTextField.text;
    NSString *Passwd =passwordTextField.text;
    NSString *FormulizeURL = @"http://formulize.dev.freeform.ca/mobile/user.php";
    
    //format login data
    NSString *login =@"login";
    NSString *postInfo =[[NSString alloc] initWithFormat:@"op=%@&pass=%@&uname=%@",login, Passwd, Uname];
    NSURL *url=[NSURL URLWithString:FormulizeURL];
    NSData *postData = [postInfo dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // Create LOGIN request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData ];
    
    //Delete previous cookies before request
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *allCookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"http://formulize.dev.freeform.ca"]];
    /*for (NSHTTPCookie *each in allCookies) {
     NSLog(@"delete:%@", each);
     [cookieStorage deleteCookie:each];
     }*/
    
    //load request
    NSError *error;
    NSHTTPURLResponse *response;
    
    NSData *urlData=[NSURLConnection  sendSynchronousRequest:request returningResponse:&response error:&error ] ;
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", data);
    
    if(error){ //case: URL is not found
    	
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL cannot be found" 
                    message:@"Please enter a valid URL" 
                   delegate:nil 
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        //check for cookies in domain
        allCookies =[ cookieStorage cookiesForURL:[NSURL URLWithString:@"http://formulize.dev.freeform.ca"]];
        NSLog(@"Connecting...");
        if ( allCookies.count > 0) {
            NSHTTPCookie *cookie = [allCookies objectAtIndex:0];
            NSLog(@"myCookie: %@", cookie.value);
            /*for (NSHTTPCookie *cookie in allCookies) {
             NSLog(@"cookie: %@ %@", cookie.name, cookie.value);
             }*/
            
            if([data rangeOfString:@"User Login : Formulize Standalone"].location == NSNotFound ){
                
                NSLog(@"logged in...");
                loggedIn = true;
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" 
                message:@"Incorrect username or password" 
               delegate:nil 
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
                [alert show];
                NSLog(@"NOT logged in...");
            }
            
            if(loggedIn){
                //new request
                // request a list of the applications
                
                NSURL *url2=[NSURL URLWithString:@"http://formulize@formulize.dev.freeform.ca/mobile/app_list.php"];
                
                NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
                [request2 setURL:url2];
                [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request2 setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData ];
                
                urlData=[NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&error ] ;
                
                data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                
                //data returned contains some HTML & js code along with the json data
                NSString * modifiedData = [data substringWithRange:NSMakeRange(0,[data rangeOfString:@"<div "].location)];
                NSData *jsondata = [modifiedData dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&error];
                
                if (error != nil) {
                    NSLog(@"Error");
                    
                }
                else {
                    if ([jsonArray count] == 0){
                        NSLog(@"You have no permission to any app");
                    }
                    for(NSDictionary *item in jsonArray) {
                        NSLog(@"%@", item);
                    }
                    
                }
                
                //check session cookie
                allCookies =[ cookieStorage cookiesForURL:[NSURL URLWithString:@"http://formulize.dev.freeform.ca"]];
                for (NSHTTPCookie *cookie in allCookies) {
                    NSLog(@"cookie: %@", cookie.value);
                }
                
                //NSLog(@"%@",data);
            }//end if (loggedIn )
        }//end if(cookies>0)
    }//end if(error)
}



@end
