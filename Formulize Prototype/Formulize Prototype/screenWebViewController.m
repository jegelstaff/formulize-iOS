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

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //load request
    [myview loadRequest:request];

}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if([[error localizedDescription] isEqualToString:@"too many HTTP redirects"]){
        
        UIAlertView *alert = [[UIAlertView alloc] 
                  initWithTitle:@"Web page does not exist" 
                  message:@"Please contact your Formulize webmaster"
                  delegate:nil 
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
