//
//  ChooseConnectionViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "ChooseConnectionViewController.h"
#import "Connection.h"
#import "AppDelegate.h"

@implementation ChooseConnectionViewController

//@synthesize tableView;
@synthesize addView;


- (void)viewWillAppear:(BOOL)animated {
    //[self.tableView reloadData];
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
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


- (void)viewDidUnload {

    [super viewDidUnload];
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
    Connection *cn = [appDelegate.connections objectAtIndex:indexPath.row];
    NSString *username = cn.username;
    NSString *password = cn.password;
    
    
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


@end
