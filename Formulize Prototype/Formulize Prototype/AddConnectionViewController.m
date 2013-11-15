//
//  ViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "AddConnectionViewController.h"
#import <Foundation/NSJSONSerialization.h>

@implementation AddConnectionViewController
@synthesize urlNameTextField;
@synthesize urlTextField;
@synthesize usernameTextField;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    
    [self setUrlTextField:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
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
    [urlNameTextField resignFirstResponder];
}

- (IBAction)saveConnection:(id)sender {
    //Commented this section out because it's not necessary. User can decide to leave username or password blank.
    //Need to modify to make sure url is not blank
    
   /* NSString *errorMsg= @"Please enter the ";
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
    }*/
    //else{
        
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(
                                                       NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] 
                        initWithString: [docsDir stringByAppendingPathComponent: 
                                         @"formulizeios.db"]];
        
        const char *dbpath = [databasePath UTF8String];
        
        sqlite3_stmt    *statement;
        
        /* open the database and insert new connection. values for the connection are gotten from each corresponding textfield. An alert view is displayed if connection was added successfully.
         */
        if (sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO connections (name, url, username, password)VALUES(\"%@\",\"%@\",\"%@\", \"%@\")",
                                   urlNameTextField.text, urlTextField.text, usernameTextField.text, passwordTextField.text];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(formulizeDB, insert_stmt, 
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Connection Added!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                
                urlNameTextField.text = @"";
                urlTextField.text = @"";
                usernameTextField.text = @"";
                passwordTextField.text = @"";
            } 
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to add connection!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                
                NSLog(@"Failed to add connnection");
            }
            sqlite3_finalize(statement);
            sqlite3_close(formulizeDB);
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate initializeDatabase];  //call the initializeDatabase method to reload the connections list
        
         
       [self.navigationController popToRootViewControllerAnimated:YES]; 
   // }
 
}

//Method to dismiss alert view
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

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
