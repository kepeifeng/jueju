//
//  WTPoetrySearchViewController.m
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 15/11/3.
//  Copyright © 2015年 Kent Peifeng Ke. All rights reserved.
//

#import "WTPoetrySearchViewController.h"

@interface WTPoetrySearchViewController ()<UISearchBarDelegate>

@end

@implementation WTPoetrySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44))];
    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
    self.navigationItem.titleView = searchBar;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    
    _items = [[WTArticleManager sharedManager] searchWithKeyword:searchBar.text];
    [_tableView reloadData];
}
@end
