//
//  WTDictionaryItemView.m
//  WorldTravel
//
//  Created by Kent on 11/17/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import "WTDictionaryItemView.h"
#import "WTVerticalTextView.h"
@implementation WTDictionaryItemView{
    UIScrollView * _scrollView;
    WTVerticalTextView * _titleView;
    WTVerticalTextView * _detailView;
    UIView * _contentView;
}

- (instancetype)init
{
    self = [super initWithTitle:nil message:nil cancelButtonTitle:nil otherButtonTitle:nil];
    if (self) {
        self.shouldDismissOnOutsideTapped = YES;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(screenBounds) * 0.8, CGRectGetHeight(screenBounds) * 0.8))];
        
        _contentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
        [_scrollView addSubview:_contentView];

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [_scrollView addGestureRecognizer:tapGesture];
        
        _titleView = [[WTVerticalTextView alloc] init];
        _titleView.font = [UIFont fontWithName:FONT_NAME size:28];
        [_contentView addSubview:_titleView];
        
        _detailView = [[WTVerticalTextView alloc] init];
        _detailView.font = [UIFont fontWithName:FONT_NAME size:18];
        _detailView.minimumLineHeight = 28;
        [_contentView addSubview:_detailView];
        
        self.contentView = _scrollView;
        
        self.padding = UIEdgeInsetsMake(20, 20, 20, 20);
        
        self.appearAnimationType = DQAlertViewAnimationTypeFlyBottom;
        self.disappearAnimationType = DQAlertViewAnimationTypeFlyBottom;
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
    
    CGSize titleViewSize = [_titleView sizeThatFits:CGSizeMake(9999, CGRectGetHeight(_contentView.bounds) - self.padding.top - self.padding.bottom)];
    _titleView.frame = CGRectMake(0, 0, titleViewSize.width, titleViewSize.height);
    
    CGSize detailViewSize = [_detailView sizeThatFits:CGSizeMake(9999, CGRectGetHeight(_contentView.bounds) - self.padding.top - self.padding.bottom)];
    _detailView.frame = CGRectMake(titleViewSize.width + 10, 0, detailViewSize.width, detailViewSize.height);
    
    
    NSArray * views = @[_titleView, _detailView];
    CGFloat width = MAX(CGRectGetMaxX(_detailView.frame), CGRectGetWidth(_scrollView.bounds) - self.padding.right - self.padding.left);
    CGSize contentSize = CGSizeMake(width + self.padding.right + self.padding.left, CGRectGetHeight(self.bounds));
    _contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
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

@end
