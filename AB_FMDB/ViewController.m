//
//  ViewController.m
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import "ViewController.h"
#import "AddUserInfo.h"

@implementation ViewController
@synthesize dbPath;
@synthesize nameArray,phoneArray,IDArray;
@synthesize table;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通讯录";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.table = tableView;
    [self.view addSubview:tableView];
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(modifyDatabase)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
}

#pragma mark -tableview-
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *CustomIdentifier =  [NSString stringWithFormat:@"cell%d",indexPath.row];
    
    static NSString *CustomIdentifier = @"cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomIdentifier];
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomIdentifier];
    }
    //    while ([cell.contentView.subviews lastObject] != nil){
    [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
    if (indexPath.row == 0)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row > 0) {
        //        cell.textLabel.text = [dataArray objectAtIndex:(indexPath.row - 1)];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0+61, 10, 120, 30)];
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(80+81, 10, 120, 30)];
        UILabel *IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(220+91, 10, 120, 30)];
        nameLabel.text = [self.nameArray objectAtIndex:(indexPath.row-1)];
        IDLabel.text = [self.IDArray objectAtIndex:(indexPath.row-1)];
        phoneLabel.text = [self.phoneArray objectAtIndex:(indexPath.row-1)];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:IDLabel];
        [cell.contentView addSubview:phoneLabel];
    }    else
    {
        for (int i = 0; i < 3; i ++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110 * i + 81, 10, 120 , 30)];
            NSArray *array = [NSArray arrayWithObjects:@"姓名",@"电话",@"ID", nil];
            label.text = [array objectAtIndex:i];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            label = nil;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nameArray count] + 1;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    else
        return indexPath;
}


- (void)createTable//创建数据库 表
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.dbPath]) {
        NSLog(@"表不存在，创建表");
        FMDatabase *db =[FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE 'USER'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'name' VARCHAR(20),'phone' VARCHAR(20),'idcode' VARCHAR(30))    ";//sql语句
            BOOL success = [db executeUpdate:sql];
            if (!success) {
                NSLog(@"error when create table ");
            }else{
                NSLog(@"create table succeed");
            }
            [db close];
        }else{
            NSLog(@"database open error");
        }
    }
}

- (void)getAllDatabase//从数据库中获得所有数据
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"SELECT * FROM USER";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            NSString *phone = [rs stringForColumn:@"phone"];
            NSString *ID = [rs stringForColumn:@"idcode"];
            
            [self.nameArray addObject:name];
            [self.phoneArray addObject:phone];
            [self.IDArray addObject:ID];
        }
        [[dataFromDataBase shareFromDataBase].nameArrayFromClass arrayByAddingObjectsFromArray:self.nameArray];
        NSLog(@"self.nameArray==%@",self.nameArray);
        [db close];
        [table reloadData];
    }
    
}

- (void)modifyDatabase
{
    NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
    
    if (indexPath == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请选择要更新的项"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        AddUserInfo *modify = [[AddUserInfo alloc]init];        modify.operateType = 1;
        [dataFromDataBase shareFromDataBase].nameFromClass = [self.nameArray objectAtIndex:(indexPath.row-1)];
        [dataFromDataBase shareFromDataBase].IDFromClass = [self.IDArray objectAtIndex:(indexPath.row-1)];
        [dataFromDataBase shareFromDataBase].phoneFromClass = [self.phoneArray objectAtIndex:(indexPath.row-1)];
        NSLog(@"datafromdatabase.nameFromClass==%@",[dataFromDataBase shareFromDataBase].nameFromClass);
        
        [self.navigationController pushViewController:modify animated:YES];//跳转到修改页面

    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"USER.sqlite"];
    self.dbPath = path;
    nameArray = [[NSMutableArray alloc]init];
    phoneArray = [[NSMutableArray alloc]init];
    IDArray = [[NSMutableArray alloc]init];
    [self createTable];
    [self getAllDatabase];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

@implementation dataFromDataBase
@synthesize nameFromClass,phoneFromClass,IDFromClass;
@synthesize nameArrayFromClass;

static dataFromDataBase *sharedInstance = nil;
+(dataFromDataBase*)shareFromDataBase
{
    if (sharedInstance == nil) {
        sharedInstance = [[dataFromDataBase alloc]init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        nameFromClass = @"";
        phoneFromClass = @"";
        IDFromClass = @"";
        nameArrayFromClass = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}


@end
