//
//  UserDetailInfo.h
//  AB_FMDB
//
//  Created by KeX on 2017/6/15.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailInfo : UIViewController<UIAlertViewDelegate>
{
    
}

@property(retain,nonatomic)NSString *dbpath;
@property(retain,nonatomic)NSString *nameStr;
@property(retain,nonatomic)NSString *phoneStr;
@property(retain,nonatomic)NSString *IDsStr;

@end
