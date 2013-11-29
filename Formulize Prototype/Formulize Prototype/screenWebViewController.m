//
//  screenWebViewController.m
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-14.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "screenWebViewController.h"

@implementation screenWebViewController

@synthesize myview;
@synthesize menuLink;
@synthesize myURL;

- (void)viewDidLoad {
    [super viewDidLoad];
     
    myview.delegate = self;  
   
    NSString* screen = [menuLink objectForKey:@"screen"];
    
    [self setTitle:[menuLink objectForKey:@"text"]];
    NSString *url = [NSString stringWithFormat:@"%@/modules/formulize/index.php?%@",myURL, screen];

    // Create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //load request
    NSLog(@"Loading Screen %@", screen);
    [myview loadRequest:request];

}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"WebView ERROR: %@", [error localizedDescription]);
    if([[error localizedDescription] isEqualToString:@"too many HTTP redirects"]){
        
        UIAlertView *alert = [[UIAlertView alloc] 
                  initWithTitle:@"You do not have permission to view this item" 
                  message:@"Please contact your Formulize webmaster"
                  delegate:nil 
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction) logout{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logoutFromURL:myURL];
}
@end
