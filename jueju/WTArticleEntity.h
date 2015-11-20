//
//  WTArticleEntity.h
//  WorldTravel
//
//  Created by Kent on 10/21/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTArticleEntity : NSObject
@property (nonatomic, assign) NSInteger entityId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, assign, getter=isFav) BOOL fav;
@end
