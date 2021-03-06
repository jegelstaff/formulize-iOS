//
//  MenuLinksTableViewController.m
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "MenuLinksTableViewController.h"

@implementation MenuLinksTableViewController

@synthesize MenuLinksText;
@synthesize menuLink;
@synthesize myURL;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    return [MenuLinksText count];
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuItemCell"];
    }
    
    cell.textLabel.text = [[MenuLinksText objectAtIndex:indexPath.row] objectForKey:@"text"];
    
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
    
    menuLink = [MenuLinksText objectAtIndex:indexPath.row];
    
    //handle external URLs
    if(![[menuLink objectForKey:@"url"] isEqualToString:@""] ){
        NSURL* externalURL = [NSURL URLWithString:[menuLink objectForKey:@"url"]];
        if (![[UIApplication sharedApplication] openURL:externalURL]){
            NSLog(@"%@%@",@"Failed to open url:",[externalURL description]);
        }
    }
    //show screen in next webView
    else{
        [self performSegueWithIdentifier:@"sendScreen" sender:nil];
    }
}


//-----------------------------------------------------------------------
//
// (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
// pass data to next screen
//
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sendScreen"]) {
        
        // Get destination view
        screenWebViewController *nextView = [segue destinationViewController];
        
        // Set the data to be sent
        [nextView setMenuLink:menuLink];
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
