//
//  ChooseConnectionViewController.m
//  Formulize Prototype
//
//  Created by Mary Nelly on 10-25-13.
//  Copyright (c) 2013 Laurentian University. All rights reserved.
//

#import "ChooseConnectionViewController.h"
#import "AddConnectionViewController.h"
#import "AppDelegate.h"

@implementation ChooseConnectionViewController

@synthesize tableView;
//@synthesize connectionArray;
@synthesize str;

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
  //  [super reloadInputViews];
    [super viewDidLoad];
    //call retrieve data method
   // [self getConnection:nil];
    
	//connections = [NSArray arrayWithObjects:@"Connection1", @"Connection2", nil];
  //  connections = [[NSArray alloc]initWithObjects:str,nil];
    //NSLog(@"url: %@",str);
    //NSLog(@"connections: %@", connections);
}

/*- (IBAction)getConnection:(id)sender {
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &formulizeDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: 
                              @"SELECT ConnectionName FROM ConnectionEntry"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(formulizeDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                NSString *connetionName = [[NSString alloc] 
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(
                                                                              statement, 0)];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSMutableArray *connectionArray = [[NSMutableArray alloc] init];
                appDelegate.connections = connectionArray;
                //[connectionArray nil];
                
                //      connectionArray = [[NSMutableArray alloc] init];
                //     [connectionArray addObject:connetionName];
                
                NSLog(@"Connection name retrieved: %@", connetionName);
                }
                
            } else {
                
                NSLog(@"Connection name could not be retrieved"); 
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(formulizeDB);
    
}//end of get connection  
 */

- (void)viewDidUnload {

    [super viewDidUnload];
}

#pragma mark - TableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.connections.count;
   //return [connections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"connectCell";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [appDelegate.connections objectAtIndex:indexPath.row];
    return cell;

    NSLog(@"Connections Array2: %@",appDelegate.connections);
}

/*-(void) passItemBack:(AddConnectionViewController *)controller didAddConnection:(NSString *)url
{
    connections = [[NSArray alloc]initWithObjects:url,nil];
    NSLog(@"url: %@",url);
    NSLog(@"connections: %@", connections);
}*/

@end
