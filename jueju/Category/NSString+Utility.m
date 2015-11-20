//
//  NSString+Utility.m
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 1/20/15.
//  Copyright (c) 2015 Kent Peifeng Ke. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

#define GROUP_MAKRER_STEP 10000
#define DIGIT_MAKRER_STEP 10

+ (NSString *)convertArabicNumbersToChinese:(NSInteger)arabicNum{
    
    NSArray *groupMarkerLabel  =  @[@"",@"万",@"亿",@"兆"];
    NSArray *digitpMarkerLabel =  @[@"",@"十",@"百",@"千"];
    NSArray *digitsLabel =  @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    
    NSInteger groupValue;
    NSMutableArray *outpus = [[NSMutableArray alloc] init];
    NSInteger zerosNumber = 0; //用来处理连续的 0
    NSInteger restNumber = arabicNum;
    NSUInteger groupMarkerPos = 0;
    
    
    do{
        //遍历 `'', '万', '亿', '兆'` 四个组
        groupValue = restNumber % GROUP_MAKRER_STEP;
        if (groupValue) {
            [outpus addObject:[groupMarkerLabel objectAtIndex:groupMarkerPos]];
        }
        
        NSUInteger digitMarkerPos = 0;
        BOOL ignoreOne = restNumber == 10;// 十位以`一`开头的时候, 可以省略`一`
        NSInteger restGroupValue = groupValue;
        BOOL trailingIsZero = arabicNum > 0; //用来处理全部以 0 来结尾的情况
        NSInteger currentUint ;
        
        do{
            // 遍历每个组的 `个, 十, 百, 千` 位, 但只从有数字的位数开始，
            // 所以最后需要做一个判断是否补零的处理
            currentUint = restGroupValue % DIGIT_MAKRER_STEP;
            
            if (trailingIsZero && currentUint) {
                trailingIsZero = NO;
            }
            
            if (currentUint) {
                [outpus addObject:[digitpMarkerLabel objectAtIndex:digitMarkerPos]];
                zerosNumber = 0;
            }else{
                zerosNumber ++;
            }
            
            if (!trailingIsZero && !ignoreOne && zerosNumber < 2) {
                [outpus addObject:[digitsLabel objectAtIndex:currentUint]];
            }
            
            digitMarkerPos ++;
            restGroupValue = floor(restGroupValue / 10);
            
            
        }while (restGroupValue > 0);
        
        
        groupMarkerPos ++;
        restNumber = floor(restNumber / GROUP_MAKRER_STEP);
        
        // 判断每个 group 是否需要补零
        // 比如 10,0001 的第一个 group 为 [0001], 但是遍历只从`各`位开始，
        // 所以对于`十`，`百`，`千` 位连续的零需要保留最后一个零，在group前补一个零
        //
        // 并且如果下一组的结尾数字是零的，也需要补一个零
        
        if (restNumber  &&
            groupValue  &&
            (groupValue < 1000 || restNumber % 10 == 0)) {
            
            zerosNumber = 1;
            [outpus addObject:[digitsLabel objectAtIndex:0]];
            
        }
        
    }while (restNumber > 0);
    
    NSMutableString *result = [NSMutableString string];
    for(int i = outpus.count - 1; i >= 0; i --){
        NSString *str = (NSString *)[outpus objectAtIndex:i];
        [result appendString:str];
    }
    
    return result;
}


@end
