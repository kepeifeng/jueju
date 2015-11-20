//
//  WTArticleManager.h
//  WorldTravel
//
//  Created by Kent on 11/2/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTArticleEntity.h"
#import "WTDynastyEntity.h"
@interface WTArticleManager : NSObject
+ (instancetype)sharedManager;

-(NSArray *)allEntity;
-(NSArray *)poetriesAtPage:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
-(NSArray *)allDynasty;
-(NSArray *)favEntities;
-(void)setFav:(BOOL)isFav forEntityId:(NSInteger)entityId;
//-(NSArray *)allPoetryOfDynasty:(NSString *)dynasty;
-(NSArray *)allPoetryOfDynasty:(NSString *)dynasty atPage:(NSInteger)pageIndex pageSize:(NSUInteger)pageSize;
-(NSArray *)searchWithKeyword:(NSString *)keyword;
-(NSString *)getMainSummaryOfPoetryId:(NSInteger)poetryId;
@end
