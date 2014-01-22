//
//  Connection.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 11-13-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "Connection.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statment = nil;

@implementation Connection
@synthesize primaryKey,name,url,username,password;


- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	if (self = [super init]) {
        primaryKey = pk;
        database = db;
        
        if (init_statement == nil) {
            const char *sql = "SELECT name,url,username,password FROM connections WHERE id=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
            self.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 1)];
            self.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 2)];
            self.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 3)];
        } else {
            self.name = @"Default Connection";
            self.url = @"formulize.ca";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
    return self;
}


-(void) deleteFromDatabase {
	if (delete_statment == nil) {
		const char *sql = "DELETE FROM connections WHERE id=?";
		if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(delete_statment, 1, self.primaryKey);
	int success = sqlite3_step(delete_statment);
	
	if (success != SQLITE_DONE) {
		NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(delete_statment);
}


@end
