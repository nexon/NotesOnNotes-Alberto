//
//  NTNModularView.m
//  NotesOnNotes-Alberto
//
//  Created by Alberto Lagos on 18-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "NTNModularView.h"



#define kArrowHeight 30
#define kMarginWidth 20

@interface NTNModularView()
@property (strong,nonatomic) UILabel    *titleLabel;
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIButton   *trashCanButton;

- (void)setup;
- (void)orientationChanged:(id)sender;
@end
@implementation NTNModularView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect frameView = CGRectMake(kMarginWidth, 0, frame.size.width - kMarginWidth*2, 150);
    self = [super initWithFrame:frameView];
    if(self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification
object:[UIDevice currentDevice]];
    
    
    self.backgroundColor     = [UIColor whiteColor];
    self.layer.borderColor   = [UIColor blackColor].CGColor;
    self.layer.borderWidth   = 1.0;
    self.layer.cornerRadius  = 5;
    self.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 110, 25)];
    self.titleLabel.text = @"Procedure";
    [self addSubview:self.titleLabel];
    
    self.trashCanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.trashCanButton.frame     = CGRectMake(self.frame.size.width - 50, 10, 25, 25);
    [self.trashCanButton setImage:[UIImage imageNamed:@"trash-50"] forState:UIControlStateNormal];
    self.trashCanButton.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.trashCanButton];
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, self.frame.size.height - 35)];
    [self.textView becomeFirstResponder];
    [self addSubview:self.textView];

}

- (void)setTargetForTrashCan:(id)target withSelector:(SEL)sel
{
    [self.trashCanButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}
- (NSString *)text
{
    return self.textView.text;
}

- (void)orientationChanged:(id)sender
{
    UIView *parentView = self.superview;
    CGRect newFrame    = self.frame;
    newFrame.size.width     = parentView.frame.size.width - kMarginWidth*2;
    self.frame              = newFrame;
    
}
- (void)setPosition:(CGRect)rect withLineHeight:(CGFloat)lineHeight
{
    CGFloat height = rect.origin.y + lineHeight;
    CGRect newFrame    = self.frame;
    
    if(height >= newFrame.size.height) {
        newFrame.origin.y  = height - (lineHeight * 10);
    } else {
        newFrame.origin.y  = height;
    }
    self.frame              = newFrame;
}
@end
