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
@synthesize scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{ 
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched)];
        
    [scrollView addGestureRecognizer:tapGesture];
    
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

//---------------------------------------------------------------------------
//
// (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// supports portrait orientation
//
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//---------------------------------------------------------------------------
//
// (BOOL)textFieldShouldReturn:(UITextField *)textField 
// hide keyboard and disable scrolling when return from a textfield
//
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    scrollView.scrollEnabled = NO;
    [scrollView setContentOffset:CGPointZero animated:YES];
    return YES;
}

//---------------------------------------------------------------------------
//
// (void)textFieldDidBeginEditing:(UITextField *)textField 
// enable scrolling when textfield begins editing 
//
//
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(300, 440);
   
    if(textField.frame.origin.y >=  usernameTextField.frame.origin.y){
        CGPoint scrollPoint = CGPointMake(0, usernameTextField.frame.origin.y-35);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

//---------------------------------------------------------------------------
//
// (IBAction)onoffSwitch:(id)sender 
// Detect change in on/off switch
//
//
- (IBAction)onoffSwitch:(id)sender {
    if([rememberMe isOn]){
        usernameTextField.enabled = YES;
        passwordTextField.enabled = YES;
        usernameTextField.backgroundColor = [UIColor whiteColor];
        passwordTextField.backgroundColor = [UIColor whiteColor];

    }
    else{
       
        usernameTextField.enabled = NO;
        passwordTextField.enabled = NO;
        usernameTextField.backgroundColor = [UIColor lightGrayColor];
        passwordTextField.backgroundColor = [UIColor lightGrayColor];
    }
}

//---------------------------------------------------------------------------
//
// (void)backgroundTouched 
// hide keyboard and disable scrolling when touch down background
//
//
- (void)backgroundTouched {
    [urlTextField resignFirstResponder];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [urlNameTextField resignFirstResponder];
    scrollView.scrollEnabled = NO;
    [scrollView setContentOffset:CGPointZero animated:YES];
}

//---------------------------------------------------------------------------
//
// saveConnection:(id)sender
// Save connection to database
//
//
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
    
    //---------------------------------------------------------------------------
    //validate user Input
    
    // User can decide to leave username or password blank.
    // case: URL textfiels is empty
    if([urlTextField.text isEqualToString:@""]){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required information is missing" 
                                message:@"Please enter a URL" 
                               delegate:nil 
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
        [alert show];
    }
    // case: URL is not valid Formulize URL
    else if(![connectionView validateURL:validateURL]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Formuize URL" 
                                                        message:@"Please enter a valid Formulize URL" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    //---------------------------------------------------------------------------
    // case: URL is not empty and is valid
    // Attempt to add connection to database
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
            
            if(![rememberMe isOn]){
                usernameTextField.text = @"";
                passwordTextField.text = @"";
            }
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
            }
            sqlite3_finalize(statement);
            sqlite3_close(formulizeDB);
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate initializeDatabase];        
         
       [self.navigationController popToRootViewControllerAnimated:YES]; 
    }
 
}

//---------------------------------------------------------------------------
//
// dismissAlert:(UIAlertView *)alertView
// Method to dismiss alert view
//
//
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}




@end
