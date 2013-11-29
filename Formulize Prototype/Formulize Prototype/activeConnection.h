//
//  activeConnection.h
//  Formulize Prototype
//
//  Created by Wedana R on 13-11-22.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface activeConnection : NSObject

@property (nonatomic,assign) NSInteger pKey;
@property (nonatomic, retain) NSString* url; 
@property (nonatomic, retain) NSString* username; 
@property (nonatomic, retain) NSString* password; 
@property (nonatomic, assign) BOOL otherUserIsLoggedIn; 


@end
