//
//  CheckBox.m
//  Watershade
//
//  Created by Devloper on 5/13/15.
//  Copyright (c) 2015 Devloper. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox

@synthesize delegate = _delegate;

#define checked_icon @"check"
#define empty_icon @""

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

// if superview tag is equal to 500. all other checkbox in the superview will deselected.
- (void)didTouchButton {
    if (self.superview.tag == 500)
    {
        for (UIView *button in self.superview.subviews) {
            if ([button isKindOfClass:CheckBox.class] && button != self)
                [self setSelectionToButton:(CheckBox *)button selected:NO inform:_delegate];
        }
        [self setSelectionToButton:self selected:allow_none?(!self->selected):YES inform:_delegate];
    }
    else
    {
        [self setSelectionToButton:self selected:!self->selected inform:_delegate];
    }
}

// sets selection to button and sets the buttom image accordingly.
- (void)setSelectionToButton:(CheckBox *)button selected:(BOOL)checkbox_selected inform:(id <CheckedDelegate>)delegate
{
    button->selected = checkbox_selected;
    if (checkbox_selected)
    {
        [((CheckBox *)button) setImage:[UIImage imageNamed:checked_icon] forState:UIControlStateNormal];
    }
    else
    {
        [((CheckBox *)button) setImage:[UIImage imageNamed:empty_icon] forState:UIControlStateNormal];
    }
    
    if (delegate)
        [delegate checkbox:self withSelection:checkbox_selected];
}

- (void)setSelected:(BOOL)selection
{
    [super setSelected:selection];
    
    [self setSelectionToButton:self selected:selection inform:nil];
}

- (void)setHitEdgeInsets:(UIEdgeInsets)edgeInsets
{
    hitEdgeInsets = edgeInsets;
}

// handeling hits on checkbox. taking in count the hitEdgeInsets. if hitEdgeInsets have minus values hits around the checkbox will be considered as a valid hits.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (BOOL)isSelected
{
    return selected;
}

- (void)setAllowNone:(BOOL)allow {
    allow_none = allow;
}

@end
