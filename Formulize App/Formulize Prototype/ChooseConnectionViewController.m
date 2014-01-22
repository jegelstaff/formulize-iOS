//
//  ChooseConnectionViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "ChooseConnectionViewController.h"


@implementation ChooseConnectionViewController
@synthesize applicationsData;
@synthesize connect;
@synthesize appData;
@synthesize CurrentConnection;


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}


//-----------------------------------------------------------------------
//
// setEditing
//
//
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    // Disable the add button while editing.
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

//-----------------------------------------------------------------------
//
// TableView Data Source methods
// commitEditingStyle
//
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Connection *cn = (Connection *)[appDelegate.connections objectAtIndex:indexPath.row];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[appDelegate removeConnection:cn];
        
        // if connection is active, remove from active connection
        [appDelegate removeActiveConnection:cn.url];
        
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
	}	
}



//-----------------------------------------------------------------------
//
// TableView data Source methods
// numberOfSectionsInTableView
//
//

#pragma mark - TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

//-----------------------------------------------------------------------
//
// TableView data Source methods
// numberOfRowsInSection
//
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.connections.count;
}


//-----------------------------------------------------------------------
//
// TableView data Source methods
// cellForRowAtIndexPath
//
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Connection *cn = [appDelegate.connections objectAtIndex:indexPath.row];
    cell.textLabel.text = cn.name;
    NSString *username = @"**username**";
    if(![cn.username isEqualToString:@""]){
        username = cn.username;
    }
    
    cell.detailTextLabel.text = username;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"notLoggedInIcon" ofType:@"png"];
   @synchronized(appDelegate.activeConnections){
    for (activeConnection * item in appDelegate.activeConnections){
        if(item.pKey == cn.primaryKey){
            path = [[NSBundle mainBundle] pathForResource:@"Icon114" ofType:@"png"];
        }
    }
   }
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;

}

//-----------------------------------------------------------------------
//
// TableView delegate methods
// didSelectRowAtIndexPath
//
//

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //get info of the selected connection
    connect = [appDelegate.connections objectAtIndex:indexPath.row];
    
    NSString *username = connect.username;
    NSString *password = connect.password;
    
    //create an activeConnection object
    CurrentConnection = [[activeConnection alloc] init] ;
    CurrentConnection.pKey = connect.primaryKey;
    CurrentConnection.url = connect.url;
    
    //check if connection is already active
    BOOL isLoggedIn = false;
    int countLoggedIn = 0;
    for (activeConnection* item in appDelegate.activeConnections){
        if(item.pKey == connect.primaryKey){
            isLoggedIn= true;
        }
        if([item.url isEqualToString:connect.url]){
            countLoggedIn++;
        }
    }
    
    //check if URL has an active connection 
    if(!isLoggedIn && countLoggedIn>0){
        CurrentConnection.otherUserIsLoggedIn = YES; 
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell isEditing] == YES) {
        //call method to push the edit screen
        [self performSegueWithIdentifier:@"editconnection" sender:nil];
    }
    else {
        //case: user is not logged in
        if(!isLoggedIn){
            //case: user is not logged in and URL is valid
            if([self validateURL:connect.url]){
                
                //case: user credentials are not saved
                if([username isEqualToString:@""] || [password isEqualToString:@""]){
                       
                    UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Login Credentials"
                                                                         message:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                               otherButtonTitles:@"Login", nil];
                    [loginalert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                    
                    UITextField *utextfield = [loginalert textFieldAtIndex:0];
                    utextfield.text = username;
                    
                    UITextField *ptextfield = [loginalert textFieldAtIndex:1];
                    ptextfield.text = password;
                
                    [loginalert show];
                }
                //case: user credentials are saved
                // attempt to login
                else{
                    CurrentConnection.username = username;
                    CurrentConnection.password = password;
                    [self validateLogin:connect.url :username :password];
                }
            }
            //case: user is not logged in and URL is not valid
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL cannot be found" 
                                message:@"Please enter a valid URL" 
                                delegate:nil 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
                [alert show];
            }
        }
        //case: user is logged in
        else{
            [self getApplicationList:connect.url];
        }
    }

}

//-----------------------------------------------------------------------
//
// connection delegate methods (1)
// didReceiveResponse
//
//
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // connection is starting, clear buffer
    NSString * requestURL = [[[connection originalRequest] URL] description];
    if([requestURL hasSuffix:@"/modules/formulize/app_list.php"] ){
        [self.appData setLength:0];
    }
}


//-----------------------------------------------------------------------
//
// connection delegate methods (2)
// didReceiveData
//
//
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString * requestURL = [[[connection originalRequest] URL] description];
    NSString* urldata =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    //case: user logged in successfully
    if([urldata isEqualToString:@"1"]){
        
       // if another user is logged into the same URL and the current login is successful
       // replace the previous user with the current user
       if(CurrentConnection.otherUserIsLoggedIn){
           [appDelegate removeActiveConnection:CurrentConnection.url];
       }
       CurrentConnection.otherUserIsLoggedIn = NO;
        
        //when a login is successful, an instance of an active object is added to the activeConnectins array
         @synchronized(appDelegate.activeConnections){
             [appDelegate.activeConnections addObject:CurrentConnection];
         }
        [self getApplicationList :CurrentConnection.url];
    }
     //case: user login failed
    else if([urldata isEqualToString:@"0"]){
        
        CurrentConnection = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" 
                            message:@"Incorrect username or password" 
                           delegate:nil 
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil];
        [alert show];
        
    }
     //case: recieved application list data 
    else if ([requestURL hasSuffix:@"/modules/formulize/app_list.php"] ){
        if(appData == nil){
            appData = [NSMutableData dataWithData:data];
        }
        else{
            [appData appendData:data];
        }
        
    }
    
}

//-----------------------------------------------------------------------
//
// connection delegate methods (3)
// connectionDidFinishLoading
//
//
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //To determine which request has finished loading
    NSString * requestURL = [[[connection originalRequest] URL] description];
   
    //case: login request finished loading
    //check if login is successful
    if([requestURL hasSuffix:@"user.php"] ){

        [self hasValidSession:connect.url];
    }
    //case: applicationList request finished loading
    //convert JSON data into an array (applicationsData)
    else if([requestURL hasSuffix:@"/modules/formulize/app_list.php"] ){
        
        NSError *error;
        applicationsData = [NSJSONSerialization JSONObjectWithData:appData options:NSJSONReadingMutableContainers error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Error getting Data" 
                                  message:@"Please try again" 
                                  delegate:nil 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
        }else {

            if ([applicationsData count] == 0){
                NSLog(@"You have no permission to any app");
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"You have no permission to any application" 
                                      message:@"Please contact your webmaster" 
                                      delegate:nil 
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                [self performSegueWithIdentifier:@"sendAppData" sender:nil]; 
            }
        }
    }    
} 
   

//-----------------------------------------------------------------------
//
// AlertView delegate methods
// didDismissWithButtonIndex
//
//
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if([alertView.title isEqualToString:@"Login Credentials"]){
        NSString *uinputText = [[alertView textFieldAtIndex:0] text];
        NSString *pinputText = [[alertView textFieldAtIndex:1] text];
        
        if (buttonIndex == 1){  
        
        	CurrentConnection.username = uinputText;
            CurrentConnection.password = pinputText;
              
            [self validateLogin:connect.url :uinputText :pinputText];
         }
    }
}


//-----------------------------------------------------------------------
//
// AlertView delegate methods
// alertViewShouldEnableFirstOtherButton
//
//
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if([alertView.title isEqualToString:@"Login Credentials"]){
        NSString *uinputText = [[alertView textFieldAtIndex:0] text];
        NSString *pinputText = [[alertView textFieldAtIndex:1] text];
        
        if( [uinputText length] >0 && [pinputText length] >0 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

//-----------------------------------------------------------------------
//
// (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
// pass data between screens
//
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editconnection"]) {
        
        // Get destination view
        EditConnectionViewController *editView = [segue destinationViewController];
        
        [editView setConnect:connect];
        
    }
    if ([[segue identifier] isEqualToString:@"sendAppData"]) {
        
        // Get destination view
        ApplicationTableViewController *nextView = [segue destinationViewController];
        [nextView setApplicationsData:applicationsData];
        [nextView setMyURL:connect.url];
    }
}



//-----------------------------------------------------------------------
//
// validateURL:url
//
//
-(BOOL)validateURL:(NSString*)url{
    
    NSURL *formulize_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php",url]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:formulize_url];

    NSURLResponse *response = nil;
    NSError *error=nil; 
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   
    NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
   
    if(httpStatus != 200)
    {
        return NO;
    }
    return YES;
}


//-----------------------------------------------------------------------
//
// validateLogin:url :username :password
//
//
-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password{
   
    // login data
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
    
    //Load Login Request
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"ERROR Logging in");
    }

}

//-----------------------------------------------------------------------
//
// hasValidSession: (NSString *) url
// check if user has a valid session in URL
//
//
-(void)hasValidSession: (NSString *) url{
    
    //new request to check if user is logged in
    NSString *check_login_url_str = [NSString stringWithFormat:@"%@/modules/formulize/isUserLoggedIn.php",url];

    NSURL *check_login_url=[NSURL URLWithString:check_login_url_str];

    NSURLRequest *request = [NSURLRequest requestWithURL:check_login_url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"ERROR checking Valid Login...");
    }

}

//-----------------------------------------------------------------------
//
// getApplicationList: (NSString *) url
// send a request to URL to get JSON data (app list)
//
-(void)getApplicationList: (NSString *) url{
    
    NSString* app_list_url_str = [NSString stringWithFormat:@"%@/modules/formulize/app_list.php", url];
    NSURL *app_list_url =[NSURL URLWithString:app_list_url_str];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:app_list_url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"error getting application list");
    }

}


@end
