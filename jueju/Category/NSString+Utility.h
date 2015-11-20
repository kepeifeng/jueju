//
//  NSString+Utility.h
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 1/20/15.
//  Copyright (c) 2015 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
- (NSString *)urlencode;

+ (NSString *)convertArabicNumbersToChinese:(NSInteger)arabicNum;
@end
