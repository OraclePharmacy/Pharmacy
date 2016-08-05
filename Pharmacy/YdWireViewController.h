//
//  YdWireViewController.h
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface YdWireViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    sqlite3 *dataBase;
}
@end
