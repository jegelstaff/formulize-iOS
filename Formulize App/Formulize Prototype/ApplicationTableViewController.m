//
//  ApplicationTableViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "ApplicationTableViewController.h"

@implementation ApplicationTableViewController

@synthesize applicationsData;
@synthesize menuLinksForApp;
@synthesize myURL;

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

#pragma mark - TableView Data Source Methods
//-----------------------------------------------------------------------
//
// TableView Data Source methods
// numberOfRowsInSection
//
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [applicationsData count];
}

//-----------------------------------------------------------------------
//
// TableView data Source methods
// cellForRowAtIndexPath :(NSIndexPath *)indexPath
//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"appCells"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"appCells"];
    }
    cell.textLabel.text = [[applicationsData objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    return cell;
}

#pragma mark - TableView Delegate Methods
//-----------------------------------------------------------------------
//
// TableView delegate methods
// didSelectRowAtIndexPath
//
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    menuLinksForApp = [[applicationsData objectAtIndex:indexPath.row] objectForKey:@"links"];
    [self performSegueWithIdentifier:@"sendMenuData" sender:nil];
}


//-----------------------------------------------------------------------
//
// (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
// pass data to next screen
//
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sendMenuData"]) {
        
        // Get destination view
        MenuLinksTableViewController *nextView = [segue destinationViewController];
        
        //set data to be sent
        [nextView setMenuLinksText:menuLinksForApp];
        [nextView setMyURL:myURL];
    }
}

//-----------------------------------------------------------------------
//
// Logout method
// request a logout using appDelegate logoutFromURL:myURL method
//
//
- (IBAction) logout{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logoutFromURL:myURL];
    
}

@end
