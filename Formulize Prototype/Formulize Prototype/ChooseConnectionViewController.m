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

NSString *connectionURL;



- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    //[appData setData:nil];
       self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}


//-----------------------------------------------------------------------
//
//setEditing
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
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	Connection *cn = (Connection *)[appDelegate.connections objectAtIndex:indexPath.row];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[appDelegate removeConnection:cn];
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}	
}

//pass application data to menuLinks screen
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sendAppData"]) {
        
        // Get destination view
        ApplicationTableViewController *nextView = [segue destinationViewController];
        [nextView setApplicationsData:applicationsData];
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    static NSString *simpleTableIdentifier = @"connectCell";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Connection *cn = [appDelegate.connections objectAtIndex:indexPath.row];
    cell.textLabel.text = cn.name;
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    connect = [appDelegate.connections objectAtIndex:indexPath.row];
    connectionURL = connect.url;
    
    if([connectionURL rangeOfString:@"http://"].location == NSNotFound ){
        connectionURL = [@"http://" stringByAppendingString:connectionURL];
    }
    
    NSString *username = connect.username;
    NSString *password = connect.password;
    
    CurrentConnection = [activeConnection alloc] ;
    CurrentConnection.connectionPK = connect.primaryKey;
    BOOL isLoggedIn = false;
    
    for (activeConnection* item in appDelegate.activeConnections){
        if(item.connectionPK == connect.primaryKey){
            isLoggedIn= true;
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell isEditing] == YES) {
        //call method to push the edit screen
        [self performSegueWithIdentifier:@"editconnection" sender:nil];
    }
    else {
        
        if(!isLoggedIn){
            
            if([self validateURL:connectionURL]){
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
            else{
                [self validateLogin:connectionURL :username :password];
            }
        }

        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL cannot be found" 
                            message:@"Please enter a valid URL" 
                            delegate:nil 
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        [self getApplicationList];
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
    if([requestURL rangeOfString:@"app_list.php"].location != NSNotFound ){
        [self.appData setData:nil];
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
    // NSLog(@"data: %@", urldata);
    
    if([urldata isEqualToString:@"1"]){
        
        NSLog(@"logged in...");
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *allCookies = [cookieStorage cookiesForURL:[NSURL URLWithString:connectionURL]];
        
        NSHTTPCookie * cookie =[allCookies objectAtIndex:0];
        CurrentConnection.cookie = cookie;

        CurrentConnection.status = @"connected";
        
        //when a login is successful, an instance of an active object is added to the activeConnectins array
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.activeConnections addObject:CurrentConnection];
        
        [self getApplicationList];
    }
    else if([urldata isEqualToString:@"0"]){
        
        NSLog(@"NOT logged in...");
        CurrentConnection = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" 
                                                        message:@"Incorrect username or password" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([requestURL rangeOfString:@"app_list.php"].location != NSNotFound ){
        if(appData == nil){
            appData =(NSMutableData *) data;
        }
        else{
            [appData appendData:(NSMutableData *)data];
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
   
    if([requestURL rangeOfString:@"app_list.php"].location != NSNotFound ){
        
        NSError *error;
        applicationsData = [NSJSONSerialization JSONObjectWithData:appData options:NSJSONReadingMutableContainers error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            
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
            [self validateLogin:connectionURL :uinputText :pinputText];
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

//pass connection data to edit screen
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editconnection"]) {
        
        // Get destination view
        EditConnectionViewController *editView = [segue destinationViewController];
        
        [editView setConnect:connect];
        
    }
}



//-----------------------------------------------------------------------
//
// validateURL:url
//
//
-(BOOL)validateURL:(NSString*)url{
    
    NSURL *login_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php",url]];
    
     NSLog(@"checkURL:%@",[login_url description]);
    NSURLRequest *request = [NSURLRequest requestWithURL:login_url];

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
    //[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData ];
    //[request setTimeoutInterval:43200];
    
    
    //check cookies before request
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *allCookies = [cookieStorage cookiesForURL:[NSURL URLWithString:connectionURL]];
    for (NSHTTPCookie *each in allCookies) {
        NSLog(@"connection cookie:%@", each.value);
        //[cookieStorage deleteCookie:each];
    }
    

    //load login request
    NSError *error;
    NSHTTPURLResponse *response;
    
    [NSURLConnection  sendSynchronousRequest:request returningResponse:&response error:&error ] ;
    
    if(error){ 
    	
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR connecting to URL" 
                                                        message:nil
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
            
            //new request to check if user is logged in
            
            NSString *check_login_url_str = [NSString stringWithFormat:@"%@/isUserLoggedIn.php",connectionURL];

            NSURL *check_login_url=[NSURL URLWithString:check_login_url_str];
        
            request = [NSURLRequest requestWithURL:check_login_url];
            NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]; 
            
            if(!connection){
                NSLog(@"error logging in...");
            }
            
            }//end if(cookies>0)
    }//end if(error)
}

//-----------------------------------------------------------------------
//
// validateLogin:url :username :password
//
//
-(void)getApplicationList{
    
    NSString* app_list_url_str = [NSString stringWithFormat:@"%@/app_list.php", connectionURL];
    NSURL *app_list_url =[NSURL URLWithString:app_list_url_str];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:app_list_url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if(!connection){
        NSLog(@"error getting application list");
    }

}


@end
