//
//  AddConnectionViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "AddConnectionViewController.h"

@implementation AddConnectionViewController
@synthesize urlNameTextField;
@synthesize urlTextField;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize rememberMe;


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
    [self setRememberMe:nil];
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
    if([rememberMe isOn]){
        usernameTextField.enabled = YES;
        passwordTextField.enabled = YES;
        usernameTextField.backgroundColor = [UIColor whiteColor];
        passwordTextField.backgroundColor = [UIColor whiteColor];

    }
    else{
        usernameTextField.text = @"";
        passwordTextField.text = @"";
        usernameTextField.enabled = NO;
        passwordTextField.enabled = NO;
        usernameTextField.backgroundColor = [UIColor lightGrayColor];
        passwordTextField.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [urlTextField resignFirstResponder];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [urlNameTextField resignFirstResponder];
}

- (IBAction)saveConnection:(id)sender {
    
    NSString * validateURL = urlTextField.text;
    // Remove / from URL if necessary
    if([ validateURL hasSuffix:@"/"]){
        validateURL = [ validateURL substringToIndex:[ urlTextField.text length] - 1];
    }

    // Append http:// to URL if necessary
    if(![ validateURL hasPrefix:@"http://"] && ![ validateURL hasPrefix:@"https://"]){
        validateURL = [@"http://" stringByAppendingString: validateURL];
    }
    
    ChooseConnectionViewController *connectionView = [[ChooseConnectionViewController alloc] init];
    // User can decide to leave username or password blank.
    // Need to make sure url is not blank
    
    if([urlTextField.text isEqualToString:@""]){
        NSLog(@"urlTextField is empty" );
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required information is missing" 
                                message:@"Please enter a URL" 
                               delegate:nil 
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
        [alert show];
    }
    else if(![connectionView validateURL:validateURL]){
        NSLog(@"invalid formuize url" );
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Formuize URL" 
                                                        message:@"Please enter a valid Formulize URL" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
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
            if([urlNameTextField.text isEqualToString:@""]){
               urlNameTextField.text = urlTextField.text;
            }
            
            urlTextField.text = validateURL;
            
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
        [appDelegate initializeDatabase];        
         
       [self.navigationController popToRootViewControllerAnimated:YES]; 
    }
 
}

//Method to dismiss alert view
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}




@end
