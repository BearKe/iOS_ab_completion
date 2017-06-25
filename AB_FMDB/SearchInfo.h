//
//  SearchInfo.h
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInfo : UITableViewController<UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UISearchDisplayController *searchController;
    NSString *namestr;
    NSString *phonestr;
    NSString *IDstr;
}
@property (retain,nonatomic)NSString *dbpath;
@property (retain,nonatomic)NSMutableArray *searchResults;//保存搜索出姓名的结果
@property (retain,nonatomic)NSMutableArray *searchPhoneResults;//保存搜索的电话信息
@property (retain,nonatomic)NSMutableArray *searchIDResult;//保存搜索的ID信息
@property (retain,nonatomic)NSMutableArray *nameArray;//保存搜索前 姓名信息
@property (retain,nonatomic)NSMutableArray *phoneArray;//保存搜索前 电话信息
@property (retain,nonatomic)NSMutableArray *IDArray;//保存搜索前 ID信息
@property (nonatomic,assign)BOOL searchWasActive;
@property (nonatomic,assign)NSString *savedSearchTerm;
@property (nonatomic,retain)NSString *namestr;
@property (nonatomic,retain)NSString*phonestr;
@property (nonatomic,retain)NSString*IDstr;

- (void)getAllDatabase;
@end
