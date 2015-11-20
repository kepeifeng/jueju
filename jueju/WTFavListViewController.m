//
//  WTFavListViewController.m
//  WorldTravel
//
//  Created by Kent on 11/5/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import "WTFavListViewController.h"

@interface WTFavListViewController ()

@end

@implementation WTFavListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[WTArticleManager sharedManager] favEntities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
