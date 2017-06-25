//
//  AddUserInfo.m
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import "AddUserInfo.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "UserDetailInfo.h"

@implementation AddUserInfo
@synthesize textFieldArray;
@synthesize dbPath;
@synthesize nameTextField;
@synthesize phoneTextField;
@synthesize IDTextField;
@synthesize operateType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        textFieldArray = [[NSMutableArray alloc]init];
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
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    NSLog(@"path===%@",path);
    self.dbPath = path;
    
    NSArray *array = [NSArray arrayWithObjects:@"姓名",@"电话",@"ID", nil];
    for (int i = 0; i < 3 ; i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake( 70,i * 40 + 34, 100, 30)];
        label.text = [array objectAtIndex:i];
        [self.view addSubview:label];
    }
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(144, 168, 144, 30)];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.delegate = self;
    [self.view addSubview:nameTextField];
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(144, 208, 144, 30)];
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.placeholder = @"请输入电话";
    phoneTextField.delegate = self;
    [self.view addSubview:phoneTextField];
    IDTextField = [[UITextField alloc]initWithFrame:CGRectMake(144, 248, 144, 30)];
    IDTextField.borderStyle = UITextBorderStyleRoundedRect;
    IDTextField.placeholder = @"请输入ID";
    IDTextField.delegate = self;
    [self.view addSubview:IDTextField];
    if (operateType == 1) {//operateType == 1时为修改
        
        nameTextField.text = [dataFromDataBase shareFromDataBase].nameFromClass;
        IDTextField.text = [dataFromDataBase shareFromDataBase].IDFromClass;
        phoneTextField.text = [dataFromDataBase shareFromDataBase].phoneFromClass;
        IDTextField.enabled = NO;
        NSLog(@"datafromdatabase.nameFromClass=%@",[dataFromDataBase shareFromDataBase].nameFromClass);
        
    }
    NSLog(@"operateType==%d",operateType);
    if (operateType == 0){
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewUserInfo)];
        self.navigationItem.rightBarButtonItem = addBtn;
    }
    if(operateType == 1){
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addNewUserInfo)];
        self.navigationItem.rightBarButtonItem = addBtn;
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addNewUserInfo
{
    FMDatabase *db = [[FMDatabase alloc]initWithPath:self.dbPath];
    NSString *mes = nil;
    if ([db open]) {
        
        if (nameTextField.text.length == 0||phoneTextField.text.length == 0||IDTextField.text.length == 0){
            mes = @"请完成填写信息";
        }else{
            NSLog(@"姓名==%@,电话==%@,ID==%@",nameTextField.text,phoneTextField.text,IDTextField.text);
            NSString *sql= nil;
            if (operateType == 0){//执行插入操作
                sql = @"INSERT INTO USER (name,phone,idcode) VALUES (?,?,?) ";
            }else if(operateType == 1)//执行更新操作
            {
                sql = @"UPDATE USER  SET name = ? , phone = ? where idcode = ?";
                
                NSLog(@"有没有执行？");
            }
            
            BOOL res = [db executeUpdate:sql,nameTextField.text,phoneTextField.text,IDTextField.text];
            if (!res) {
                NSLog(@"error to insert data");
                mes = @"数据插入错误";
            }else{
                NSLog(@"insert succeed");
                mes = @"数据插入成功";
            }
        }
    }else{
        NSLog(@"数据库打开失败") ;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert setTag:101];
    alert.delegate = self;
    [alert show];
    [db close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 && buttonIndex == 0) {
        if (operateType == 0)
        {
            [nameTextField resignFirstResponder];
            [phoneTextField resignFirstResponder];
            [IDTextField resignFirstResponder];
            nameTextField.text = @"";
            phoneTextField.text = @"";
            IDTextField.text = @"";
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [IDTextField resignFirstResponder];
}//键盘隐藏

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated//页面将要消失的时候执行，将UITextField清空
{
    [super viewWillDisappear:YES];
    nameTextField.text = nil;
    phoneTextField.text = nil;
    IDTextField.text = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
