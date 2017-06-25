//
//  UserDetailInfo.m
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import "UserDetailInfo.h"
#import "FMDatabase.h"


@implementation UserDetailInfo
@synthesize dbpath;
@synthesize nameStr,phoneStr,IDsStr;


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
    self.title = @"详细信息";
    NSArray *array = [NSArray arrayWithObjects:@"姓名:",@"电话:",@"ID:", nil];
    NSArray *array2 = [NSArray arrayWithObjects:self.nameStr,self.phoneStr,self.IDsStr, nil];
    
    for (int i = 0; i < 3 ; i++)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70,i * 40 + 134, 150, 30)];
        label.text = [array objectAtIndex:i];
        [self.view addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(140, i * 40 +135, 150, 30)];
        label2.text = [array2 objectAtIndex:i];
        [self.view addSubview:label2];
    }
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"USER.sqlite"];
    self.dbpath = path;
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteFromDatabase)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)deleteFromDatabase//从数据库删除信息
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
    NSString *mes = nil;
    if ([db open]) {
        NSString *sql = @"DELETE FROM USER WHERE name = ? and phone = ? and idcode = ?";
        if (self.nameStr.length != 0&&self.phoneStr.length != 0&&self.IDsStr.length !=0){
            BOOL rs = [db executeUpdate:sql,self.nameStr,self.phoneStr,self.IDsStr]; //后面跟的三个参数就是sql语句里的三个问号对应
            if (rs) {
                mes = @"删除成功";
            }else{
                mes = @"删除失败";
            }
        }
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate = self;//别忘了代理
    [alert show];
    [db close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"点击了删除成功");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
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
