//
//  AddUserInfo.h
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AddUserInfo : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    int operateType;//保存操作类型    0是添加 1是修改
}
- (void)createTable;
@property (retain,nonatomic)NSMutableArray *textFieldArray;
@property (retain,nonatomic)NSString *dbPath;
@property (retain,nonatomic)UITextField *nameTextField;
@property (retain,nonatomic)UITextField *phoneTextField;
@property (retain,nonatomic)UITextField *IDTextField;
@property (nonatomic,assign)int operateType;
@end
