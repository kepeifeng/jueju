//
//  WTArticleView.h
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 15/10/31.
//  Copyright © 2015年 Kent Peifeng Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTVerticalTextView.h"
#import "WTArticleEntity.h"

@interface WTArticleView : UIScrollView<WTVerticalTextViewDelegate>
@property (nonatomic, strong) WTArticleEntity * article;

@property (nonatomic, strong) WTVerticalTextView * titleView;
@property (nonatomic, strong) WTVerticalTextView * authorLabel;
@property (nonatomic, strong) WTVerticalTextView * contentLabel;
@property (nonatomic, assign) UIEdgeInsets padding;
-(void)layout;
@end
