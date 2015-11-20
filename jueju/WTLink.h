//
//  WTLink.h
//  WorldTravel
//
//  Created by Kent on 11/16/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  WTAttributedStringLink <NSObject>

@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSString * link;
@end
