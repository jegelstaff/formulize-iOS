//
//  EditConnectionViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 11-21-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "EditConnectionViewController.h"

@implementation EditConnectionViewController
@synthesize urlNameTextField;
@synthesize urlTextField;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize rememberMe;
@synthesize connect;
@synthesize scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched)];
    
    [scrollView addGestureRecognizer:tapGesture];
    
    //show connection data in textFields
    
    urlNameTextField.text = connect.name;
    urlTextField.text = connect.url;
    if ([connect.username isEqualToString:@""] || [connect.password isEqualToString:@""])
    {
        usernameTextField.enabled = NO;
        passwordTextField.enabled = NO;
        usernameTextField.backgroundColor = [UIColor lightGrayColor];
        passwordTextField.backgroundColor = [UIColor lightGrayColor];
        
        [rememberMe setOn:NO];
    }
    else
    {
        usernameTextField.text = connect.username;
        passwordTextField.text = connect.password;
    }    
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

//-----------------------------------------------------------
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
// updateConnection:(id)sender
// check before updating connection in database
//
//
- (IBAction)updateConnection:(id)sender {
    
    NSString * validateURL = urlTextField.text;
    // Remove / from URL if necessary
    if([ validateURL hasSuffix:@"/"]){
        validateURL = [ validateURL substringToIndex:[ urlTextField.text length] - 1];
    }
    
    // Append http:// to URL if necessary
    if(![ validateURL hasPrefix:@"http://"] && ![ validateURL hasPrefix:@"https://"]){
        validateURL = [@"http://" stringByAppendingString: validateURL];
    }
    
    //---------------------------------------------------------------------------
    //validate user Input
    
    ChooseConnectionViewController *connectionView = [[ChooseConnectionViewController alloc] init];
    // User can decide to leave username or password blank.
    // Need to make sure url is not blank
    
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
    else{
        
        if([urlNameTextField.text isEqualToString:@""]){
            urlNameTextField.text = urlTextField.text;
        }
        
        if(![rememberMe isOn]){
             usernameTextField.text = @"";
             passwordTextField.text = @"";
        }
        
        urlTextField.text = validateURL;
        self.connect.name = urlNameTextField.text;
        self.connect.url = urlTextField.text;
        self.connect.username = usernameTextField.text;
        self.connect.password = passwordTextField.text;
        
        [self updateConnectionInDatabase];
        
        [self.navigationController popToRootViewControllerAnimated:YES];   
    }
    
}

//---------------------------------------------------------------------------
//
// (void)updateConnectionInDatabase
// update connection in database
//
//
-(void)updateConnectionInDatabase
{
    NSInteger pk = self.connect.primaryKey;
    
    //update in  database
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
    
    sqlite3_stmt *updateStmt;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
    {
        const char *sql = "UPDATE connections SET name = ?, url = ?, username = ?, password = ? Where id=?";
        if(sqlite3_prepare_v2(formulizeDB, sql, -1, &updateStmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(updateStmt, 1, [urlNameTextField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(updateStmt, 2, [urlTextField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(updateStmt, 3, [usernameTextField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(updateStmt, 4, [passwordTextField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(updateStmt, 5, pk);
        }
        char* errmsg;
        sqlite3_exec(formulizeDB, "COMMIT", NULL, NULL, &errmsg);

        if(SQLITE_DONE != sqlite3_step(updateStmt)){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to update connection!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
            NSLog(@"Error while updating. %s", sqlite3_errmsg(formulizeDB));
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Connection updated!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
        }
        sqlite3_finalize(updateStmt);
        sqlite3_close(formulizeDB);
    }
}



//---------------------------------------------------------------------------
//
// (void)dismissAlert:(UIAlertView *) alertView
// Method to dismiss alert view
//
//

-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
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
// (void)textFieldDidBeginEditing:(UITextField *)textField 
// enable scrolling when textfield begins editing 
//
//
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(200, 440);
    
    if(textField.frame.origin.y >=  usernameTextField.frame.origin.y){
        CGPoint scrollPoint = CGPointMake(0, usernameTextField.frame.origin.y-35);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

@end
