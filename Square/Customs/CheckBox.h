//
//  CheckBox.h
//  Watershade
//
//  Created by Devloper on 5/13/15.
//  Copyright (c) 2015 Devloper. All rights reserved.
//
//
// can work as multiple choice group if added to a view with tag = 500
//
//

#import <UIKit/UIKit.h>
#import "RoundedCornersButton.h"

@protocol CheckedDelegate <NSObject>

@required
- (void)checkbox:(UIView *)checkBox withSelection:(BOOL)selected;
@end

@interface CheckBox : RoundedCornersButton
{
@private
    __weak id <CheckedDelegate> _delegate;
    
    BOOL selected, allow_none;
    UIEdgeInsets hitEdgeInsets; // hitting area offset. can be minus which will increaase the hitting area.
}

@property (nonatomic,weak) id <CheckedDelegate> delegate;

- (BOOL)isSelected;
- (void)setSelectionToButton:(CheckBox *)button selected:(BOOL)checkbox_selected inform:(id <CheckedDelegate>)delegate;
- (void)setHitEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)setAllowNone:(BOOL)allow;

@end