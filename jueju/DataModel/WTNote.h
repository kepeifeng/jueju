//
//  WTNote.h
//  WorldTravel
//
//  Created by Kent on 11/5/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTLink.h"

@interface WTNote : NSObject<WTAttributedStringLink>
@property (nonatomic) NSRange range;
@property (nonatomic) NSInteger index;
///如: 锱铢
@property (nonatomic) NSString * itemName;
///如: 锱铢(zizhu)
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * detail;
@end
