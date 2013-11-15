//
//  screenWebViewController.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-14.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface screenWebViewController : UIViewController{
    UIWebView* myview;

}
@property(nonatomic, retain)IBOutlet UIWebView* myview;
@property(nonatomic, strong)  NSString *screen;
@property(nonatomic, strong)  NSString *menuID;


@end
