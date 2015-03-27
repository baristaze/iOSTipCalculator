//
//  BillView.m
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillView.h"
#import "TipView.h"

#define MARGIN_BIG 20.0
#define MARGIN_SMALL 15.0
#define LABEL_HEIGHT 60.0
#define BUTTON_HEIGHT 60.0

#define DECIMAL_10 [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]]
#define DECIMAL_CENT [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:0.01] decimalValue]]
#define NUMBER_MAX [NSNumber numberWithFloat:9999.99f]]

// ----------------------------------------------------------- //

@implementation BillView

- (id)initWith:(TipCalculator*)tipCalculator
{
    // assign tip calculator
    _tipCalculator = tipCalculator;
    
    // initialize data
    _currentVal = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:0.0f] decimalValue]];
    
    // status bar height
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)]){
    
        [self setBackgroundColor:[UIColor blackColor]];
         
        // calculate locations of the buttons
        CGFloat left = MARGIN_BIG;
        CGFloat top = statusBarHeight + MARGIN_BIG;
        
        // create labels
        CGFloat halfSize = (screenWidth - 2 * MARGIN_BIG - MARGIN_SMALL) / 2.0f;
        CGRect descRect = CGRectMake(left, top, halfSize-20, LABEL_HEIGHT);
        UILabel* _descriptionLabel = [[UILabel alloc] initWithFrame:descRect];
        _descriptionLabel.font = [UIFont systemFontOfSize:18];
        _descriptionLabel.numberOfLines = 1;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.backgroundColor = [UIColor blackColor];
        [_descriptionLabel setText:@"Bill Amount: "];
        // add it to the subview
        [self addSubview:_descriptionLabel];
        
        CGRect labelRect = CGRectMake(left + halfSize + MARGIN_SMALL - 20, top, halfSize + 20, LABEL_HEIGHT);
        _billAmountLabel = [[UILabel alloc] initWithFrame:labelRect];
        _billAmountLabel.font = [UIFont systemFontOfSize:30];
        _billAmountLabel.numberOfLines = 1;
        _billAmountLabel.textAlignment = NSTextAlignmentRight;
        _billAmountLabel.textColor = [UIColor blackColor];
        _billAmountLabel.backgroundColor = [UIColor whiteColor];
        [_billAmountLabel setText:@"$0.00"];
        
        // add it to the subview
        [self addSubview:_billAmountLabel];
        
        // create buttons
        // calculate button width
        CGFloat buttonWidth = (screenWidth - (2 * MARGIN_BIG) - (2 * MARGIN_SMALL)) / 3;
        
        // increase
        top += LABEL_HEIGHT + MARGIN_BIG - BUTTON_HEIGHT;
        
        // 1 2 3
        // 4 5 6
        // 7 8 9
        // x 0 k
        // create buttons [1, 2, 3, 4, 5, 6, 7, 8, 9]
        for(int x=1; x<=12; x++){
            
            // create button
            UIButton* numberButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            // calculate the button text
            NSString* faceVal = [NSString stringWithFormat:@"%d", x];
            if(x == 10){
                faceVal = @"erase";
            }
            else if(x == 11){
                faceVal = @"0";
            }
            else if(x == 12){
                faceVal = @"OK";
            }
            
            // set number on the button
            [numberButton setTitle:faceVal forState:UIControlStateNormal];
            [numberButton setBackgroundColor:[UIColor whiteColor]];
            [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            // [numberButton.titleLabel setFont:[UIFont fontWithName:@"System" size:24]];
            
            // set the data as tag
            numberButton.tag = x;
            
            // register onTap event
            [numberButton addTarget:self
                             action:@selector(numberButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            // adjust x and y location for current button
            if(x%3 == 1){ // 1, 4, 7, del
                // advance y location
                top += BUTTON_HEIGHT + MARGIN_BIG;
                // reset x location
                left = MARGIN_BIG;
            }
            
            // set frame for the button
            numberButton.frame = CGRectMake(left, top, buttonWidth, BUTTON_HEIGHT);
            
            // advance X location
            left += buttonWidth + MARGIN_SMALL;
            
            // add it to the view
            [self addSubview:numberButton];
        }
    }
    return self;
}

- (IBAction) numberButtonTapped:(id)sender
{
    // cast to button as the sender is a button
    UIButton* button = (UIButton *)sender;
    
    // get data from button
    int data = (int)[button tag];
    if(data == 10){
        
        // erase tapped...
        // get current value as text
        NSString* billAmountAsText = _billAmountLabel.text;
        
        // get last digit
        NSInteger labelLength = [billAmountAsText length];
        NSString* lastDigitAsText = [billAmountAsText substringWithRange:NSMakeRange(labelLength-1, 1)];
        NSDecimalNumber* lastDigit = [NSDecimalNumber decimalNumberWithString:lastDigitAsText];
        
        // update the current value
        _currentVal = [_currentVal decimalNumberBySubtracting:[lastDigit decimalNumberByMultiplyingBy:DECIMAL_CENT]];
        _currentVal = [_currentVal decimalNumberByDividingBy:DECIMAL_10];

    }
    else if(data == 11){
        
        // 0 tapped
        if([_currentVal compare:NUMBER_MAX <= 0){
            _currentVal = [_currentVal decimalNumberByMultiplyingBy:DECIMAL_10];
        }
    }
    else if(data == 12){
        
        // OK tapped
        _tipCalculator.billAmount = _currentVal;
        
        TipView* tipView = [[TipView alloc] initWith:_tipCalculator];
        [self addSubview:tipView];
    }
    else{
        
        // main case: we have new input
        if([_currentVal compare:NUMBER_MAX <= 0){
            _currentVal = [_currentVal decimalNumberByMultiplyingBy:DECIMAL_10];
            NSDecimalNumber* dataDecimal = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:data] decimalValue]];
            _currentVal = [_currentVal decimalNumberByAdding:[dataDecimal decimalNumberByMultiplyingBy:DECIMAL_CENT]];
        }
    }
    
    // update bill label
    [_billAmountLabel setText:[TipCalculator decimalAsCurrency:_currentVal]];
}


@end