//
//  WTBasicEntityListViewController.h
//  WorldTravel
//
//  Created by Kent on 11/5/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WTArticleManager.h"
#import "WTArticleViewController.h"

@interface WTBasicEntityListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView * _tableView;
    NSArray * _items;
}


@end
