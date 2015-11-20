//
//  WTSqliteViewController.m
//  WorldTravel
//
//  Created by Kent on 10/21/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import "WTSqliteViewController.h"

#import "WTArticleManager.h"
#import "WTArticleViewController.h"
#import "WTAlertAction.h"
#import "WTPoetrySearchViewController.h"
#import "WTFavListViewController.h"

@interface WTSqliteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) BOOL currentPageIndex;
@end

#define kPageSize (20.0)

@implementation WTSqliteViewController{

    UITableView * _tableView;
    NSMutableArray * _items;
    
    UISearchController * _searchController;
    BOOL _displayed;
    
    UIBarButtonItem * _dynastyItem;
    WTDynastyEntity * _currentDynasty;
    NSArray * _dynastyArray;
    
    BOOL _reachEnd;
    
    UIView * _loadMoreView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绝    句";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    _loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 80)];
    UIActivityIndicatorView * spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    spinView.center = _loadMoreView.center;
    [spinView startAnimating];
    [_loadMoreView addSubview:spinView];
    
//    _loadMoreView.textColor = [UIColor lightGrayColor];
    
    
//    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30))];
//    
//    _tableView.tableHeaderView = searchBar;
    
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(searchItemTapped:)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    _dynastyItem = [[UIBarButtonItem alloc] initWithTitle:@"朝代" style:(UIBarButtonItemStylePlain) target:self action:@selector(dynastyItemTapped:)];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem * favItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-heart-empty"] style:(UIBarButtonItemStylePlain) target:self action:@selector(favItemTapped:)];
    self.toolbarItems = @[_dynastyItem, spaceItem, favItem];
    self.navigationController.toolbarHidden = NO;
    [self loadData];

}
-(void)favItemTapped:(id)sender{

    WTFavListViewController * favListVC = [[WTFavListViewController alloc] init];
    [self.navigationController pushViewController:favListVC animated:YES];
}

-(void)searchItemTapped:(id)sender{

    WTPoetrySearchViewController * searchVC = [[WTPoetrySearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_displayed == NO) {
        _displayed = YES;
        [self restoreIndexPath];
    }
}

-(void)dynastyItemTapped:(id)sender{

    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    if (!_dynastyArray) {
        _dynastyArray = [[WTArticleManager sharedManager] allDynasty];
    }
    
    for (WTDynastyEntity * dynasty in _dynastyArray) {
        WTAlertAction * action = [WTAlertAction actionWithTitle:dynasty.title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//            WTAlertAction * alertAction = (WTAlertAction *)action;
            [self selectDynasty:dynasty];
        }];
        
        [alertControl addAction:action];
    }
    
    WTAlertAction * action = [WTAlertAction actionWithTitle:@"全部" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self selectDynasty:nil];
    }];
    [alertControl addAction:action];
    
    WTAlertAction * cancelAction = [WTAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertControl addAction:cancelAction];
    
    [self presentViewController:alertControl animated:YES completion:NULL];
}

-(void)selectDynasty:(WTDynastyEntity *)dynasty{

    NSLog(@"%@", dynasty);
    _currentDynasty = dynasty;
    
    if (!dynasty) {

        _dynastyItem.title = @"全部";
     
    }else{
        _dynastyItem.title = dynasty.title;
    }
    _reachEnd = NO;
    [self loadDataAtPageIndex:0];
    
}


-(void)loadDataAtPageIndex:(NSInteger)pageIndex{

    if (_reachEnd == YES) {
        return;
    }
    
    if (pageIndex == 0) {
        _items = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    NSArray * newItems;
    if (_currentDynasty == nil) {
//        (_items.count == 0)? 0 : self.currentPageIndex+1
        newItems = [[WTArticleManager sharedManager] poetriesAtPage:pageIndex pageSize:kPageSize];
        
    }else{
    
        newItems = [[WTArticleManager sharedManager] allPoetryOfDynasty:_currentDynasty.title atPage:pageIndex pageSize:kPageSize];
    }
    
    if (newItems.count <kPageSize) {
        _reachEnd = YES;
        _tableView.tableFooterView = nil;
    }else{
        _tableView.tableFooterView = _loadMoreView;
    }
    
    
    
    NSMutableArray * indexPathArray = [[NSMutableArray alloc] initWithCapacity:newItems.count];
    for (NSInteger i = 0; i < newItems.count; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:_items.count + i inSection:0]];
    }
    
    [_items addObjectsFromArray:newItems];
    
    //    [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:(UITableViewRowAnimationNone)];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    _items = [[NSMutableArray alloc] initWithCapacity:100];
    [self tryLoadMore];
//    [_tableView reloadData];
}

-(void)restoreIndexPath{
    
    NSInteger row = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tableViewIndexPath"] integerValue];
    
    if (row < _items.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
    }
    
}
-(void)saveCurrentIndexPath{

    CGPoint point = _tableView.contentOffset;
    point.y += _tableView.contentInset.top;
    NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:point];
    if (indexPath) {
        [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"tableViewIndexPath"];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (decelerate == NO) {
        [self saveCurrentIndexPath];
        [self tryLoadMore];

    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewDidEndDecelerating");
    [self saveCurrentIndexPath];
    [self tryLoadMore];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    
    WTArticleEntity * entity = _items[indexPath.row];
    cell.textLabel.text = entity.title;
    cell.detailTextLabel.text = entity.content;
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WTArticleEntity * entity = _items[indexPath.row];

    WTArticleViewController * articleVC = [[WTArticleViewController alloc] init];
//    articleVC.articleEntity = entity;
    articleVC.entityArray = _items;
    articleVC.defaultIndex = indexPath.row;
    
    [self.navigationController pushViewController:articleVC animated:YES];
}




-(BOOL)currentPageIndex{

    return (_items.count+kPageSize/2) / kPageSize;
}

-(void)tryLoadMore{

    
    if (_tableView.contentOffset.y + CGRectGetHeight(_tableView.bounds) > _tableView.contentSize.height - 80 && _reachEnd == NO ) {
        [self loadDataAtPageIndex:self.currentPageIndex + 1];
    }
    
}
@end


