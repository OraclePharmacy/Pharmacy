//
//  YdmingchengViewController.h
//  Pharmacy
//
//  Created by suokun on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface YdmingchengViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *dataBase;
}
@property (nonatomic,strong) NSString *sanji;

@end
