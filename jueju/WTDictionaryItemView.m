//
//  WTDictionaryItemView.m
//  WorldTravel
//
//  Created by Kent on 11/17/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import "WTDictionaryItemView.h"
#import "WTVerticalTextView.h"

@interface WTDictionaryItemView ()

@property (nonatomic, strong) UIView * blackOpaqueView;

@end

@implementation WTDictionaryItemView{
    UIScrollView * _scrollView;
    WTVerticalTextView * _titleView;
    WTVerticalTextView * _detailView;
    UIView * _innerContentView;
    UIView * emptyView;
}

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
//        self.shouldDismissOnOutsideTapped = YES;
        
        self.blackOpaqueView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.blackOpaqueView addGestureRecognizer:outsideTapGesture];
        [self addSubview:self.blackOpaqueView];
        
        CGFloat containerHeight = 160.0;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - containerHeight, CGRectGetWidth(screenBounds), containerHeight)];
        
        emptyView.backgroundColor = [UIColor whiteColor];
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        emptyView.layer.shadowColor = [[UIColor blackColor] CGColor];
        emptyView.layer.shadowOpacity = 0.3;
        emptyView.layer.shadowOffset = CGSizeMake(0, -5);
        emptyView.layer.masksToBounds = NO;

        [self addSubview:emptyView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:emptyView.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//        _scrollView.backgroundColor = [UIColor whiteColor];
        [emptyView addSubview:_scrollView];

        
        _innerContentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
        [_scrollView addSubview:_innerContentView];

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [_scrollView addGestureRecognizer:tapGesture];
        
        _titleView = [[WTVerticalTextView alloc] init];
        _titleView.font = [UIFont fontWithName:FONT_NAME size:28];
        [_innerContentView addSubview:_titleView];
        
        _detailView = [[WTVerticalTextView alloc] init];
        _detailView.font = [UIFont fontWithName:FONT_NAME size:18];
        _detailView.minimumLineHeight = 28;
        [_innerContentView addSubview:_detailView];
        
        
//        self.contentView = _scrollView;
        
        self.padding = UIEdgeInsetsMake(20, 20, 20, 20);
        
//        self.appearAnimationType = DQAlertViewAnimationTypeFlyBottom;
//        self.disappearAnimationType = DQAlertViewAnimationTypeFlyBottom;
    }
    return self;
}

-(void)setNote:(WTNote *)note{
    _note = note;
    [self updateView];
    
}

-(void)updateView{

    _titleView.text = self.note.title;
    _detailView.text = self.note.detail;
    
    CGFloat maxHeight = CGRectGetHeight(_innerContentView.bounds) - self.padding.top - self.padding.bottom;
    
    CGSize titleViewSize = [_titleView sizeThatFits:CGSizeMake(9999, maxHeight)];
    _titleView.frame = CGRectMake(0, 0, titleViewSize.width, titleViewSize.height);
    
    CGSize detailViewSize = [_detailView sizeThatFits:CGSizeMake(9999, maxHeight)];
    _detailView.frame = CGRectMake(titleViewSize.width + 10, 0, detailViewSize.width, detailViewSize.height);
    
    
    NSArray * views = @[_titleView, _detailView];
    CGFloat width = MAX(CGRectGetMaxX(_detailView.frame), CGRectGetWidth(_scrollView.bounds) - self.padding.right - self.padding.left);
    CGSize contentSize = CGSizeMake(width + self.padding.right + self.padding.left, CGRectGetHeight(_innerContentView.bounds));
    _innerContentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    _scrollView.contentSize = contentSize;
    //反向排列
    for (UIView * view in views) {
        CGRect frame = view.frame;
        frame.origin.y = self.padding.top;
        frame.origin.x = width - CGRectGetMaxX(frame) + self.padding.left;
        view.frame = frame;
    }
    
    _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - CGRectGetWidth(_scrollView.bounds), 0);
    
}

-(void)scrollViewTapped:(UITapGestureRecognizer *)tap{

    [self dismiss];
}

-(void)show{
    
    UIView *superView;
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    if ([ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 8.0 ) {
        superView = window;
    } else {
        superView = [[window subviews] lastObject];
    }
    
    [self showInView:superView];

}

- (void)outsideTap:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];

}

- (void)showInView:(UIView *)view
{
    
//    UIView *window = [[[UIApplication sharedApplication] delegate] window];

//    self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];

    self.blackOpaqueView.alpha = 0;
    emptyView.alpha = 0;
    emptyView.transform = CGAffineTransformMakeTranslation(0, 20);
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackOpaqueView.alpha = 1;
        emptyView.alpha = 1;
        emptyView.transform = CGAffineTransformIdentity;
    }];
    

}

-(void)dismiss{

    [UIView animateWithDuration:0.3 animations:^{
        self.blackOpaqueView.alpha = 0;
        emptyView.alpha = 0;
        emptyView.transform = CGAffineTransformMakeTranslation(0, 50);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
