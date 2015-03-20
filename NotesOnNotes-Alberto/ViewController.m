//
//  ViewController.m
//  NotesOnNotes-Alberto
//
//  Created by Alberto Lagos on 18-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "ViewController.h"
#define kMarginWidth 20

@interface ViewController ()
@property (weak, nonatomic)    IBOutlet UITextView *textView;
@property (nonatomic)          BOOL                locked;
@property (strong, nonatomic)  UIPopoverController *popOverContainer;
@property (strong, nonatomic)  NTNModularView      *modularView;
@property (strong, nonatomic)  NSLayoutConstraint  *adjustableHeight;
@property (strong, nonatomic)  NSString            *selectedText;
@property (strong, nonatomic)  UITextRange         *selectedTextRange;

- (void)trashCanDidPress:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIMenuItem *highlightMenuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlight)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:highlightMenuItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeCustomContraint:) name:@"alberto.lagos.NotesOnNotes.removeConstraint.Notification"
                                               object:nil];
    
    self.locked = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)highlight
{
    NSRange selectedRange  = self.textView.selectedRange;
    self.selectedTextRange = self.textView.selectedTextRange;
    
    self.selectedText = [self.textView textInRange: self.textView.selectedTextRange];
    CGFloat height = [self.textView caretRectForPosition:self.textView.selectedTextRange.end].origin.y;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:self.textView.typingAttributes];
    
    [attributedString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor purpleColor]
                             range:selectedRange];

    
    self.textView.scrollEnabled = NO;
    self.textView.attributedText = attributedString;
    self.textView.scrollEnabled = YES;
    
    self.locked = YES;
    
    self.modularView = [[NTNModularView alloc] initWithFrame:self.view.frame];
    [self.modularView setTargetForTrashCan:self withSelector:@selector(trashCanDidPress:)];

    [self.view addSubview:self.modularView];
    
    self.adjustableHeight = [NSLayoutConstraint constraintWithItem:self.modularView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:[self calculateConstantWith:height]];
    
    [self updateViewConstraints];
    
}

- (void)trashCanDidPress:(id)sender
{
    NSLog(@"%s: %@", __func__, self.modularView.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"alberto.lagos.NotesOnNotes.removeConstraint.Notification"
                                                        object:nil];
    [self.modularView removeFromSuperview];
    self.locked = NO;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    self.textView.editable      = !_locked;
    self.textView.selectable    = !_locked;
}

- (void)setupConstraints
{
    
}

- (void)orientationChanged:(id)sender
{
    
    if(self.locked) {
        self.locked = NO;
        self.textView.selectedTextRange = self.selectedTextRange;
        CGRect rect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
        self.adjustableHeight.constant  = [self calculateConstantWith:rect.origin.y];        
        self.locked = YES;
    }
    
}

- (void)updateViewConstraints
{
    if(self.adjustableHeight) {
        
        [self.view addConstraint:self.adjustableHeight];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modularView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modularView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modularView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:150]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modularView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:0.0]];
    }
    
    [super updateViewConstraints];
}

- (CGFloat)calculateConstantWith:(CGFloat)base
{
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
    CGFloat offset = self.textView.contentOffset.y;
    CGFloat heightModularView = self.modularView.frame.size.height;

    if(base < heightModularView) {
        base += self.textView.font.lineHeight;
    } else {
        if(offset == 0) {
            base -= heightModularView;
        } else {
            if((base - offset) < heightModularView) {
                base -= offset;
            } else {
                base -= (heightModularView + offset);
            }
        }
    }
    self.textView.scrollEnabled = NO;
    return base;
}


#pragma - mark Custom Methods for Notification

- (void)removeCustomContraint:(id)notification
{
    self.textView.scrollEnabled = YES;
    self.adjustableHeight = nil;
}
@end
