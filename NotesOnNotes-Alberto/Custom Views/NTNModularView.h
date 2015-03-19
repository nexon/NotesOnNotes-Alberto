//
//  NTNModularView.h
//  NotesOnNotes-Alberto
//
//  Created by Alberto Lagos on 18-03-15.
//  Copyright (c) 2015 Alberto Lagos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTNModularView : UIView

- (void)setTargetForTrashCan:(id)target withSelector:(SEL)sel;
- (NSString *)text;
- (void)setPosition:(CGRect)rect withLineHeight:(CGFloat)lineHeight;
@end
