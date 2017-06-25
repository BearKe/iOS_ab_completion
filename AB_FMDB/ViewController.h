//
//  ViewController.h
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


@class dataFromDataBase;
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, retain) NSString * dbPath;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) NSMutableArray *phoneArray;
@property (nonatomic, retain) NSMutableArray *IDArray;

@property (nonatomic, retain) UITableView *table;
- (void)createTable;
@end

@interface dataFromDataBase : NSObject { //保存数据
@private
    NSString *nameFromClass;
    NSString *phoneFromClass;
    NSString *IDFromClass;
    NSMutableArray *nameArrayFromClass;
}
+(dataFromDataBase*)shareFromDataBase;
@property(retain,nonatomic) NSString *nameFromClass;

@property(retain,nonatomic)NSString *phoneFromClass;

@property(retain,nonatomic)NSString *IDFromClass;
@property(retain,nonatomic)NSMutableArray *nameArrayFromClass;

@end
