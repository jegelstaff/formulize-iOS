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
@synthesize menuLinkScreen;
@synthesize menuLinkID;

@synthesize sendData;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for(NSDictionary *item in MenuLinksText) {
        NSLog(@"menuitem: %@", [item objectForKey:@"text"]);
    }
    
}

#pragma mark - TableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MenuLinksText count];
}


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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    menuLinkScreen = [[MenuLinksText objectAtIndex:indexPath.row] objectForKey:@"screen"];
   // NSLog(@"screen: %@",menuLinkScreen);
    
    menuLinkID = [[MenuLinksText objectAtIndex:indexPath.row] objectForKey:@"menu_id"];
   // NSLog(@"menu_id: %@",menuLinkID);
    
    [self performSegueWithIdentifier:@"sendScreen" sender:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sendScreen"]) {
        
        // Get destination view
        screenWebViewController *nextView = [segue destinationViewController];
        
        // Set the data to be sent
        
        [nextView setScreen:menuLinkScreen];
        [nextView setMenuID:menuLinkID];
    }
}

@end
