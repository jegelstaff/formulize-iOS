//
//  activeConnection.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-22.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface activeConnection : NSObject

@property (nonatomic) NSInteger connectionPK;
@property (nonatomic, retain) NSHTTPCookie* cookie;
@property (nonatomic, retain) NSString* status; 


@end
