//
//  WTVerticalTextView.h
//  WorldTravel
//
//  Created by Kent on 10/30/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTLink.h"

@protocol WTVerticalTextViewDelegate;

@interface WTVerticalTextView : UIView{
    NSAttributedString * _attributedText;
}

@property (nonatomic, weak) id<WTVerticalTextViewDelegate> delegate;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSAttributedString * attributedText;
@property (nonatomic, copy) UIFont * font;
@property (nonatomic, assign) CGFloat minimumLineHeight;
@property (nonatomic, strong) NSArray * links;

-(void)updateAttributedString;

@end


@protocol WTVerticalTextViewDelegate <NSObject>
@optional
-(void)textView:(WTVerticalTextView *)textView linkTapped:(id<WTAttributedStringLink>)link;

@end