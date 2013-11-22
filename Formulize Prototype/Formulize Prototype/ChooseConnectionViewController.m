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
@synthesize Login;
@synthesize isLoggedIn;
@synthesize connect;

NSString *connectionURL;

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

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

#pragma mark - TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.connections.count;
}


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

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    connect = [appDelegate.connections objectAtIndex:indexPath.row];
    connectionURL = connect.url;
    NSString *username = connect.username;
    NSString *password = connect.password;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell isEditing] == YES) {
        //call method to push the edit screen
        [self performSegueWithIdentifier:@"editconnection" sender:nil];
    }
    else {
        
        isLoggedIn = false;
        if(!isLoggedIn){
            if( [username isEqualToString:@""] || [password isEqualToString:@""]){
            
           
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
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString* urldata =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if([urldata characterAtIndex:0] =='1'){
        isLoggedIn= true;
        NSLog(@"logged in...");
        
        //request applications list
        NSURL *app_list_url =[NSURL URLWithString:@"http://formulize@formulize.dev.freeform.ca/mobile/app_list.php"];
        
        NSMutableURLRequest* request = [NSURLRequest requestWithURL:app_list_url];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        if(!connection){
            NSLog(@"error getting app list");
        }
    }
    else if([urldata isEqualToString:@"0"]){
        isLoggedIn= false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" 
                                                        message:@"Incorrect username or password" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"NOT logged in...");
    }
    else{
        
        NSError *error;
        applicationsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (error != nil) {
            NSLog(@"Error");
            
        }else {
            if ([applicationsData count] == 0){
                NSLog(@"You have no permission to any app");
            }
        }
        [self performSegueWithIdentifier:@"sendAppData" sender:Login];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"click");
    NSString *uinputText = [[alertView textFieldAtIndex:0] text];
    NSString *pinputText = [[alertView textFieldAtIndex:1] text];
    
    if (buttonIndex == 1){    
        [self validateLogin:connectionURL :uinputText :pinputText];
     }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
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
    if ([[segue identifier] isEqualToString:@"editconnection"]) {
        
        // Get destination view
        EditConnectionViewController *editView = [segue destinationViewController];
        
        [editView setConnect:connect];
        
    }

}

-(void)validateLogin:(NSString*)url :(NSString*)username :(NSString*)password{
    // login data
    NSString *login =@"login";
    NSString *postInfo =[[NSString alloc] initWithFormat:@"op=%@&pass=%@&uname=%@",login, password, username];
    NSURL *login_url=[NSURL URLWithString:url];
    NSData *postData = [postInfo dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    
    // Create LOGIN request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:login_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData ];
    [request setTimeoutInterval:250];
    
    
    //Delete previous cookies before request
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *allCookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"http://formulize.dev.freeform.ca"]];
    for (NSHTTPCookie *each in allCookies) {
        NSLog(@"delete:%@", each);
        [cookieStorage deleteCookie:each];
    }
    
    //load login request
    NSError *error;
    NSHTTPURLResponse *response;
    
    [NSURLConnection  sendSynchronousRequest:request returningResponse:&response error:&error ] ;
    
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
            
            //new request to check if user is logged in
            
            NSURL *check_login_url=[NSURL URLWithString:@"http://formulize.dev.freeform.ca/mobile/isUserLoggedIn.php"];
            request = [NSURLRequest requestWithURL:check_login_url];
            NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]; 
            
            if(!connection){
                NSLog(@"error logging in...");
            }
            
        }//end if(cookies>0)
    }//end if(error)
}



@end
