//
//  WTVerticalTextView.m
//  WorldTravel
//
//  Created by Kent on 10/30/15.
//  Copyright © 2015 Kent Peifeng Ke. All rights reserved.
//

#import "WTVerticalTextView.h"
#import <CoreText/CoreText.h>

static dispatch_queue_t myQueue;

@interface WTVerticalTextView ()
@property (atomic, assign) BOOL needsUpdateAttributeString;
@property (atomic, assign) BOOL needsUpdateFrameSetter;
@end
@implementation WTVerticalTextView{
    
    NSMutableArray * lineInfoForTap;
    
    CTFramesetterRef _framesetter;
    CTFrameRef _frame;
    
    NSOperationQueue * _operationQueue;
    
    UIImage * _renderedImage;
}
@synthesize font = _font;
@synthesize attributedText = _attributedText;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumLineHeight = 28;
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestuseHandler:)];
        self.exclusiveTouch = NO;
        [self addGestureRecognizer:tapGesture];
        
        
        
        if (!myQueue) {
            myQueue = dispatch_queue_create("My Queue",NULL);
        }
        
        
        
        //        self.clearsContextBeforeDrawing = YES;
        
    }
    return self;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    self.needsUpdateAttributeString = YES;
}

//-(NSAttributedString *)attributedText{
//    return _attributedText;
//}

-(UIFont *)font{
    
    if (!_font) {
        return [UIFont fontWithName:@"HiraMinProN-W3" size:14];
    }
    return _font;
}

-(void)setText:(NSString *)text{
    _text = text;
    //    [self updateAttributedString];
    self.needsUpdateAttributeString = YES;
}

-(void)setLinks:(NSArray *)links{
    _links = links;
    self.needsUpdateAttributeString = YES;
}
-(NSAttributedString *)attributedText{
    
    if (self.needsUpdateAttributeString) {
        [self updateAttributedString];
    }
    
    self.needsUpdateAttributeString = NO;
    
    return _attributedText;
}
-(void)updateAttributedString{
    
    if (!_text) {
        _attributedText = nil;
        //        [self setNeedsDisplay];
        return;
    }
    
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:_text attributes:nil];
    
    //    CTParagraphStyleSetting settings[1];
    //    CTParagraphStyleSetting setting;
    //    setting.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    //    CGFloat height = 28.0;
    //    setting.valueSize = sizeof(height);
    //    setting.value = &height;
    //    settings[0] = setting;
    //
    //    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = self.minimumLineHeight;
    
    [attributed addAttributes:@{NSFontAttributeName:self.font, //吐血, 用 systemFont 就会排版出错
                                NSVerticalGlyphFormAttributeName:@(YES),
                                NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributed.length)];
    
    for (id<WTAttributedStringLink> link in _links) {
        [attributed addAttribute:@"MyURLAttribute" value:link.link range:link.range];
    }
    _attributedText = attributed;
    self.needsUpdateFrameSetter = YES;
    
    //    [self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.needsUpdateFrameSetter = YES;
}

-(void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    self.needsUpdateFrameSetter = YES;
}

-(void)updateFrameSetter{
    
    
    
    if (self.needsUpdateFrameSetter == NO) {
        return;
    }
    
    if(self.attributedText.length == 0){
        _renderedImage = nil;
        return;
    }
    
    
    /*
     self.needsUpdateFrameSetter = NO;
     [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
     
     return;
     */
    
    
    
    dispatch_async(myQueue, ^{
        // Perform long running process
        [self updateCacheImage];
        self.needsUpdateFrameSetter = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self setNeedsDisplay];
        });
    });
    
    
    //        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    
    
}

-(void)updateCacheImage{
    
    
    @synchronized(self) {
        if (_framesetter)
        {
            CFRelease(_framesetter);
            _framesetter = NULL;
        }
        
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
        
        if (!_framesetter) {
            NSLog(@"_framesetter is NULL!");
        }
        CGPathRef path = CGPathCreateWithRect(CGRectMake(0.0, 0.0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds)), nil);
        
        if (_frame)
        {
            CFRelease(_frame);
            _frame = NULL;
        }
        
        _frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, nil);
        
        CGPathRelease(path);
        
        CGRect rect = self.bounds;
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextRotateCTM(context, M_PI_2);
        //    CGContextTranslateCTM(context, 30.0, 35.0);//偏移
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTFrameDraw(_frame, context);
        
        _renderedImage = UIGraphicsGetImageFromCurrentImageContext();

        
        
        //    CGPathRef path = CGPathCreateWithRect(CGRectMake(0.0, 0.0, rect.size.height, rect.size.width), nil);
        
        //    CGRect frameBoundingBox = CGPathGetBoundingBox(path);
        CGRect frameBoundingBox = rect;
        CFArrayRef lines = CTFrameGetLines(_frame);
        CGPoint origins[CFArrayGetCount(lines)];                              // the origins of each line at the baseline
        CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
        CFIndex linesCount = CFArrayGetCount(lines);
        lineInfoForTap = [[NSMutableArray alloc] initWithCapacity:10];
        for (int lineIdx = 0; lineIdx < linesCount; lineIdx++)
        {
            CGContextSetTextPosition(context, origins[lineIdx].x + frameBoundingBox.origin.x, frameBoundingBox.origin.y + origins[lineIdx].y);
            CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, lineIdx);
            CGRect lineBounds = CTLineGetImageBounds(line, context);
            lineBounds = CGRectMake(lineBounds.origin.y, lineBounds.origin.x, lineBounds.size.height, lineBounds.size.width);
            //        lineBounds.origin.y = self.frame.size.height - origins[lineIdx].y - lineBounds.size.height;
            CFRange lineRange = CTLineGetStringRange(line);
            
            [lineInfoForTap addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSStringFromRange(NSMakeRange(lineRange.location, lineRange.length)), @"Range", NSStringFromCGRect(lineBounds), @"Bounds", nil]];
            
            
            /*
             UIBezierPath * path = [UIBezierPath bezierPathWithRect:lineBounds];
             [[[UIColor redColor] colorWithAlphaComponent:0.5] setFill];
             [path fill];
             */
            
        }
        
        UIGraphicsEndImageContext();
        
    }
}


-(void)tapGestuseHandler:(UITapGestureRecognizer *)gesture{
    NSLog(@"tapGestuseHandler");
    
    CGPoint location = [gesture locationInView:self];
    
    dispatch_async(myQueue, ^{
        id<WTAttributedStringLink> link = [self getLinkAtPoint:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (link) {
                if ([self.delegate respondsToSelector:@selector(textView:linkTapped:)]) {
                    [self.delegate textView:self linkTapped:link];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(textView:blankAreaTapped:)]) {
                    [self.delegate textView:self blankAreaTapped:location];
                }
            }

        });
        
    });
    
    
    
    
    //    _linkLocation = location;
    
    //    location = CGPointMake(location.y, location.x);
    
    
}

-(id<WTAttributedStringLink>)getLinkAtPoint:(CGPoint)location{
    
    
    CFArrayRef lines = CTFrameGetLines(_frame);
    
    CGPoint origins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
    
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    //    NSInteger index = 0;
    
    
    for (NSInteger index = 0; index< lineInfoForTap.count; index++)
    {
        NSDictionary* lineInfo = lineInfoForTap[index];
        
        CGRect lineBounds = CGRectFromString([lineInfo valueForKey:@"Bounds"]);
        //        NSRange lineRange = NSRangeFromString([lineInfo valueForKey:@"Range"]);
        if(CGRectContainsPoint(lineBounds, location))
        {
            line = (CTLineRef)CFArrayGetValueAtIndex(lines, index);
            lineOrigin = lineBounds.origin;
            //            CFRange range = CTLineGetStringRange(line);
            location.x -= lineOrigin.x;
            location.y -= lineOrigin.y;
            location = CGPointMake(location.y, location.x);
            CFIndex touchIndex = CTLineGetStringIndexForPosition(line, location);
            if (touchIndex>=self.attributedText.length) {
                return nil;
            }
            NSLog(@"Index: %ld",touchIndex);
            
            id<WTAttributedStringLink> link = [self linkAtIndex:touchIndex];
            
            return link;
            
            break;
        }
        
    }
    
    return nil;
}


-(id<WTAttributedStringLink>)linkAtIndex:(NSUInteger)index{
    
    for (id<WTAttributedStringLink> link in _links) {
        if (index >= link.range.location && index <= link.range.location+link.range.length) {
            return link;
        }
    }
    
    return nil;
}

-(void)dealloc{
    [self clearFrameSetter];
}


-(void)clearFrameSetter{
    if (_framesetter)
    {
        CFRelease(_framesetter);
        _framesetter = NULL;
    }
    
    if (_frame)
    {
        CFRelease(_frame);
        _frame = NULL;
    }
}
/*
 -(void)willMoveToSuperview:(UIView *)newSuperview{
 [super willMoveToSuperview:newSuperview];
 NSLog(@"%@\t willMoveToSuperview",self);
 }
 */

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    //    NSLog(@"%@\t willMoveToWindow\t %@",self, newWindow);
    
    if (self.needsUpdateFrameSetter && newWindow) {
        [self updateFrameSetter];
        //        [_operationQueue cancelAllOperations];
        ////        for (NSOperation * operation in [_operationQueue.operations copy]) {
        ////            [operation cancel];
        ////        }
        //
        //        [_operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        //            [self updateFrameSetter];
        //        }]];
        //        [self performSelectorInBackground:@selector(updateFrameSetter) withObject:nil];
    }else if (newWindow == nil){
        //        [self clearFrameSetter];
        
    }
    [self setNeedsDisplay];
}
/*
 
 -(void)didMoveToSuperview{
 [super didMoveToSuperview];
 NSLog(@"%@\t didMoveToSuperview",self);
 }
 
 -(void)didMoveToWindow{
 [super didMoveToWindow];
 NSLog(@"%@\t didMoveToWindow",self);
 }
 
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    if (self.needsUpdateFrameSetter == YES) {
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
        return;
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    @try {
        [_renderedImage drawAtPoint:(CGPointZero)];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        CGContextRestoreGState(context);
    }
    
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touchesBegan");
    
    [super touchesBegan:touches withEvent:event];

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (BOOL)isChinese:(NSString *)s index:(int)index {
    NSString *subString = [s substringWithRange:NSMakeRange(index, 1)];
    const char *cString = [subString UTF8String];
    return strlen(cString) == 3;
}


-(CGSize)sizeThatFits:(CGSize)size{
    
    CGRect titleRect = [self.attributedText boundingRectWithSize:CGSizeMake(size.height, size.width)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin)
                                                         context:nil];
    
    return CGSizeMake(CGRectGetHeight(titleRect), CGRectGetWidth(titleRect));
    
}
@end
