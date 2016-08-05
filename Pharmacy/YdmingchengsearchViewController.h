//
//  YdmingchengsearchViewController.h
//  Pharmacy
//
//  Created by suokun on 16/8/4.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface YdmingchengsearchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *dataBase;
}
@end
