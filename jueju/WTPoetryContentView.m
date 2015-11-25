//
//  WTPoetryContentView.m
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 15/11/4.
//  Copyright © 2015年 Kent Peifeng Ke. All rights reserved.
//

#import "WTPoetryContentView.h"
#import <CoreText/CoreText.h>
#import "NSString+Utility.h"
#import "WTNote.h"

@implementation WTPoetryContentView

-(void)updateAttributedString{

    [super updateAttributedString];
    
    return;
    
    if (self.text.length == 0) {
        return;
    }
    

    

    
    NSRegularExpression * numberExp = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\d+)\\]" options:0 error:nil];
    NSMutableAttributedString * newString = [_attributedText mutableCopy];
    
    NSArray<NSTextCheckingResult *> * matches = [numberExp matchesInString:self.text options:0 range:(NSMakeRange(0, self.text.length))];
    NSInteger offset = 0;
//    UIFont * markFont = [UIFont fontWithName:self.font.fontName size:9];

/*
    for (NSTextCheckingResult * result in matches) {
        
        NSMutableString * matchString = [[self.text substringWithRange:result.range] mutableCopy];
        [numberExp replaceMatchesInString:matchString options:0 range:NSMakeRange(0, matchString.length) withTemplate:@"$1"];
        NSString * chineseNumberString = [NSString convertArabicNumbersToChinese:[matchString integerValue]];
        NSAttributedString * numberString = [[NSAttributedString alloc] initWithString:chineseNumberString attributes:@{NSVerticalGlyphFormAttributeName:@(YES),
                                                                                                                        NSFontAttributeName:markFont,
                                                                                                                        (NSString *)kCTSuperscriptAttributeName:@(1),
                                                                                                                        NSVerticalGlyphFormAttributeName:@(YES)}];
        
        NSRange range = NSMakeRange(result.range.location - offset, result.range.length);
        [newString replaceCharactersInRange:range withAttributedString:numberString];
        offset+=(result.range.length - numberString.length);

    }
    
*/

    

    for (NSTextCheckingResult * result in matches) {

   

        NSMutableString * matchString = [[self.text substringWithRange:result.range] mutableCopy];
        [numberExp replaceMatchesInString:matchString options:0 range:NSMakeRange(0, matchString.length) withTemplate:@"$1"];
        NSString * chineseNumberString = [NSString convertArabicNumbersToChinese:[matchString integerValue]];
        // Ruby Annotation
        CFStringRef furiganaRef[kCTRubyPositionCount] = {
            (__bridge CFStringRef) chineseNumberString, NULL, NULL, NULL
        };
        CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(kCTRubyAlignmentAuto, kCTRubyOverhangAuto, 1, furiganaRef);
        //CFSTR("HiraMinProN-W6")
        CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName, 9, NULL);
        CFStringRef keys[] = { kCTFontAttributeName, kCTRubyAnnotationAttributeName,kCTVerticalFormsAttributeName};
        CFBooleanRef vertical = (__bridge CFBooleanRef)@(YES);
        
        CFTypeRef values[] = { font, ruby, vertical};
        
        CFDictionaryRef attr = CFDictionaryCreate(NULL,
                                                  (const void **)&keys,
                                                  (const void **)&values,
                                                  sizeof(keys) / sizeof(keys[0]),
                                                  &kCFTypeDictionaryKeyCallBacks,
                                                  &kCFTypeDictionaryValueCallBacks);
        
        CFAttributedStringRef attributes = CFAttributedStringCreate(NULL, (__bridge CFStringRef)@" ", attr);
        CFRelease(attr);
        
        NSAttributedString * numberString = (__bridge NSAttributedString *)(attributes);
        NSRange range = NSMakeRange(result.range.location - offset, result.range.length);
        [newString replaceCharactersInRange:range withAttributedString:numberString];
        offset+=(result.range.length - numberString.length);
        CFAutorelease(attributes);

        

        
/*
        NSMutableString * matchString = [[self.text substringWithRange:result.range] mutableCopy];
        [numberExp replaceMatchesInString:matchString options:0 range:NSMakeRange(0, matchString.length) withTemplate:@"$1"];
        NSString * chineseNumberString = [NSString convertArabicNumbersToChinese:[matchString integerValue]];
        NSAttributedString * numberString = [[NSAttributedString alloc] initWithString:chineseNumberString attributes:@{NSVerticalGlyphFormAttributeName:@(YES),
                                                                                                                        NSFontAttributeName:markFont,
                                                                                                                        (NSString *)kCTSuperscriptAttributeName:@(1),
                                                                                                                        NSVerticalGlyphFormAttributeName:@(YES)}];
        
        NSRange range = NSMakeRange(result.range.location - offset, result.range.length);
        [newString replaceCharactersInRange:range withAttributedString:numberString];
        offset+=(result.range.length - numberString.length);

    */
    }

    
    _attributedText = newString;
}

@end
