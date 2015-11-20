//
//  WTDictionaryItemView.h
//  WorldTravel
//
//  Created by Kent on 11/17/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import <DQAlertView/DQAlertView.h>
#import "WTNote.h"

@interface WTDictionaryItemView : DQAlertView
@property (nonatomic) WTNote * note;

@property (nonatomic, assign) UIEdgeInsets padding;
@end
