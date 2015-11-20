//
//  WTArticleViewController.h
//  WorldTravel
//
//  Created by Kent on 10/21/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTArticleEntity.h"

@interface WTArticleViewController : UIViewController

@property (nonatomic, strong) NSArray * entityArray;
@property (nonatomic, assign) NSInteger defaultIndex;
@end
