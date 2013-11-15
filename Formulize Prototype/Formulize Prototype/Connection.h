//
//  Connection.h
//  Formulize Prototype
//
//  Created by Mary Nelly on 11-13-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Connection : NSObject{
	sqlite3   *database;
    NSInteger primaryKey;
	NSString  *name;
    NSString *url;
    NSString *username;
    NSString *password;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;


- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)deleteFromDatabase;


@end
