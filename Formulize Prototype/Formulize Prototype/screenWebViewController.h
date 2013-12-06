//
//  screenWebViewController.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-14.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface screenWebViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView* myview;
    NSDictionary *menuLink;
    NSString *myURL;
}
@property(nonatomic, retain)IBOutlet UIWebView* myview;
@property(nonatomic, strong, retain)  NSDictionary *menuLink;
@property(nonatomic, strong, retain)  NSString *myURL;

- (IBAction) logout;

@end
