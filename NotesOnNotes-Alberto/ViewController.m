//
//  ViewController.m
//  NotesOnNotes-Alberto
//
//  Created by Alberto Lagos on 18-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic)    IBOutlet UITextView *textView;
@property (nonatomic)          BOOL                locked;
@property (strong, nonatomic)  UIPopoverController *popOverContainer;
@property (strong, nonatomic)  NTNModularView      *modularView;

- (void)trashCanDidPress:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIMenuItem *highlightMenuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlight)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:highlightMenuItem]];
    
    self.locked = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
   
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (void)highlight
{
    NSRange selectedTextRange = self.textView.selectedRange;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    
    
    
    [attributedString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor purpleColor]
                             range:selectedTextRange];
    
    self.locked = YES;
    
    self.modularView = [[NTNModularView alloc] initWithFrame:self.view.frame];
    [self.modularView setTargetForTrashCan:self withSelector:@selector(trashCanDidPress:)];
    [self.view addSubview:self.modularView];
    
    self.textView.scrollEnabled = NO;
    self.textView.attributedText = attributedString;
    self.textView.scrollEnabled = YES;
}

- (void)trashCanDidPress:(id)sender
{
    NSLog(@"%s: %@", __func__, self.modularView.text);
    [self.modularView removeFromSuperview];
    self.locked = NO;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    self.textView.editable   = !_locked;
    self.textView.selectable = !_locked;
}
@end
