//
//  SearchInfo.m
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import "SearchInfo.h"
#import "FMDatabase.h"
#import "ViewController.h"
#import "UserDetailInfo.h"

@implementation SearchInfo
@synthesize dbpath;
@synthesize searchResults,searchPhoneResults,searchIDResult;
@synthesize nameArray,phoneArray,IDArray;
@synthesize searchWasActive;
@synthesize savedSearchTerm;
@synthesize namestr,phonestr,IDstr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width -50, 44)];
    search.placeholder = @"请输入姓名";
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    search.showsScopeBar = YES;
    search.delegate = self;
    search.keyboardType = UIKeyboardTypeNamePhonePad;
    self.tableView.tableHeaderView = search;
    self.tableView.dataSource = self;
    
    searchController = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    searchController.active = NO;
    
    searchController.delegate = self;
    
    searchController.searchResultsDelegate=self;
    
    searchController.searchResultsDataSource = self;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"user.sqlite"];
    NSLog(@"path==%@",path);
    self.dbpath = path;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    nameArray = [[NSMutableArray alloc]initWithCapacity:0];
    phoneArray = [[NSMutableArray alloc]initWithCapacity:0];
    IDArray= [[NSMutableArray alloc]initWithCapacity:0];
    
    [self getAllDatabase];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.searchWasActive = [self.searchDisplayController isActive];
    if (self.searchDisplayController.searchBar != 0)
    {
        self.searchDisplayController.searchBar.text = nil;
        [self.searchDisplayController.searchBar resignFirstResponder];
        [self.searchDisplayController setActive:NO];
    }
}

- (void)getAllDatabase{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
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
        self.searchResults = [[NSMutableArray alloc]initWithArray:nameArray copyItems:YES];
        self.searchPhoneResults = [[NSMutableArray alloc]initWithArray:phoneArray copyItems:YES];
        self.searchIDResult = [[NSMutableArray alloc]initWithArray:IDArray copyItems:YES];
        NSLog(@"search from nameArray==%@",self.nameArray);
        [db close];
    }
}


#pragma mark -tableview-

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.tableView = tableView;
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
       
    }else{
        cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        row = [self.searchResults count];
    }else{
        [self.nameArray count];
    }
    return row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetailInfo *detailInfo = [[UserDetailInfo alloc]init];
    detailInfo.nameStr = [self.searchResults objectAtIndex:indexPath.row];
    detailInfo.phoneStr = [self.searchPhoneResults objectAtIndex:indexPath.row];
    detailInfo.IDsStr = [self.searchIDResult objectAtIndex:indexPath.row];
    NSLog(@"self.namestr==%@",self.namestr);
    
    NSArray *array = [self.navigationController viewControllers];//先获取视图控制器数组
    UINavigationController *nav = [array objectAtIndex:[array count] - 1];//获取当前的导航试图控制器
    [nav.navigationController pushViewController:detailInfo animated:YES];//跳转到删除页面
}


#pragma mark -UISearchControllerDisplay-//设置搜索范围


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self searchBarSearchButtonClicked:self.searchDisplayController.searchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar//从数据库搜索
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
    if ([db open]) {
        
        [searchResults removeAllObjects];
        [searchPhoneResults removeAllObjects];
        [searchIDResult removeAllObjects];
        NSString *sql = @"SELECT * FROM USER WHERE name like ?";
        FMResultSet *rs = [db executeQuery:sql,searchBar.text];
        while ([rs next]) {
            self.namestr = [rs stringForColumn:@"name"];
            self.phonestr = [rs stringForColumn:@"phone"];
            self.IDstr = [rs stringForColumn:@"idcode"];
            
            [self.searchResults addObject:namestr];
            [self.searchPhoneResults addObject:phonestr];
            [self.searchIDResult addObject:IDstr];
        }
        
        NSLog(@"searchResults == %@",searchResults);
        NSLog(@"searchPhoneResults==%@",searchPhoneResults);
        NSLog(@"searchIDResult==%@",searchIDResult);
        NSLog(@"search===%@",searchBar.text);
        
    }
    [db close];
    
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods设置代理方法

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
