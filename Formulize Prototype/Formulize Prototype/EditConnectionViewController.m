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
@synthesize connect;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    urlNameTextField.text = connect.name;
    urlTextField.text = connect.url;
    usernameTextField.text = connect.username;
    passwordTextField.text = connect.password;
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

- (IBAction)updateConnection:(id)sender {
    
    self.connect.name = urlNameTextField.text;
    self.connect.url = urlTextField.text;
    self.connect.username = usernameTextField.text;
    self.connect.password = passwordTextField.text;
    
    [self updateConnectionInDatabase:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];     
    
}

-(void)updateConnectionInDatabase:(id)sender
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
    }
    char* errmsg;
    sqlite3_exec(formulizeDB, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(formulizeDB));
    }
    else{
        NSLog(@"Connection updated");
    }
    sqlite3_finalize(updateStmt);
    sqlite3_close(formulizeDB);

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTouched:(id)sender {
    [urlTextField resignFirstResponder];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [urlNameTextField resignFirstResponder];
}

@end
