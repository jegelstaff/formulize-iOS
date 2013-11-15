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
@synthesize screen;
@synthesize menuID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   /* 
    screen=@"sid=9";
    menuID=@"11";
    
    NSString *url = [NSString stringWithFormat:@"http://formulize.dev.freeform.ca/mobile/modules/formulize/index.php?%@&menuid=%@",screen, menuID];
    
    NSString *postInfo =[[NSString alloc] initWithFormat:@"%@&menuid=%@",screen, menuID];
    NSURL *load_url=[NSURL URLWithString:url];
    NSLog(@"%@",postInfo);
    NSData *postData = [postInfo dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
   
    // Create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:load_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData ];
    
    NSError *error;
    NSHTTPURLResponse *response;
    
    NSData *urlData = [NSURLConnection  sendSynchronousRequest:request returningResponse:&response error:&error ] ;
    
    if(error){ //case: URL is not found
        NSLog(@"error %@", [error localizedDescription]);	
    }
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@", data);
    [myview loadHTMLString:data baseURL:nil];*/
    
    [myview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://formulize.dev.freeform.ca/mobile"]]];
}

@end
