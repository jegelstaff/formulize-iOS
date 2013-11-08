//
//  ViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "AddConnectionViewController.h"
#import "AppDelegate.h"

@implementation AddConnectionViewController
@synthesize urlNameLabel;
@synthesize urlNameTextField;
@synthesize urlLabel;
@synthesize urlTextField;
@synthesize usernameLabel;
@synthesize usernameTextField;
@synthesize passwordLabel;
@synthesize passwordTextField;



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
            NSLog(@"creating table");
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ConnectionEntry (ID INTEGER PRIMARY KEY AUTOINCREMENT, ConnectionName TEXT, ConnectionURL TEXT, Username TEXT, Password TEXT)";
            
            if (sqlite3_exec(formulizeDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status = @"Failed to create table";
                NSLog(status);
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




@end
