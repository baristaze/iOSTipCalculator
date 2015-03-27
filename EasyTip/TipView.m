//
//  TipView.m
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipView.h"

#define ROW_HEIGHT 60.0
#define BUTTON_HEIGHT 60.0
#define MARGIN_BIG 20.0
#define MARGIN_SMALL 15.0

@interface TipView(private)

-(UILabel*)createLabelWithRow:(NSUInteger)rowIndex isLeft:(BOOL)isLeftSide title:(NSString*)text;
-(UISlider*) createSlider;
-(void) createButtons;

@end

// *****************************//

@implementation TipView

- (id)initWith:(TipCalculator*) tipCalculator
{
    // assign tip calculator
    _tipCalculator = tipCalculator;
    
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)]){
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        [self createLabelWithRow:0
                          isLeft:TRUE
                            title:@"Bill Amount:"];
        
        [self createLabelWithRow:0
                          isLeft:FALSE
                            title:[TipCalculator decimalAsCurrency:_tipCalculator.billAmount]];
        
        
        [self createLabelWithRow:1
                          isLeft:TRUE
                           title:@"Tip Rate:"];
        
        //NSString* rateAsText = [[[_tipCalculator tipRate] decimalNumberByMultiplyingByPowerOf10:2] stringValue];
        //rateAsText = [rateAsText stringByAppendingString:@" %"];
        
        _tipRateLabel = [self createLabelWithRow:1
                          isLeft:FALSE
                           title:@"0 %"];
        //                   title:rateAsText];

        
        [self createLabelWithRow:2
                          isLeft:TRUE
                            title:@"Tip Amount:"];
        
        _tipLabel = [self createLabelWithRow:2
                          isLeft:FALSE
                            title:[TipCalculator decimalAsCurrency:[_tipCalculator getTipAmount]]];
         
         [self createLabelWithRow:3
                           isLeft:TRUE
                             title:@"TOTAL:"];
         
         _totalLabel = [self createLabelWithRow:3
                           isLeft:FALSE
                             title:[TipCalculator decimalAsCurrency:[_tipCalculator getGrandTotal]]];
        
        // add slider
        [self createSlider];
        
        // add a close button
        [self createButtons];
        
    }
    return self;
}

- (UILabel*) createLabelWithRow:(NSUInteger)rowIndex isLeft:(BOOL)isLeftSide title:(NSString*)text
{
    // status bar height
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    // calculate locations
    CGFloat halfSize = (screenWidth - 2 * MARGIN_BIG - MARGIN_SMALL) / 2.0f;
    CGFloat left = MARGIN_BIG;
    CGFloat top = statusBarHeight + MARGIN_BIG + (rowIndex * (MARGIN_SMALL + ROW_HEIGHT));
    if(!isLeftSide){
        left += MARGIN_SMALL + halfSize;
    }
    
    // create
    CGRect rect = CGRectMake(left, top, halfSize, ROW_HEIGHT);
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [label setText:text];

    if(isLeftSide){
        label.textAlignment = NSTextAlignmentLeft;
    }
    else{
        label.textAlignment = NSTextAlignmentRight;
    }
    
    // add
    [self addSubview:label];
    
    // return
    return label;
}

-(UISlider*) createSlider
{
    // status bar height
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    // calculate location
    CGFloat left = MARGIN_BIG;
    CGFloat top = statusBarHeight + MARGIN_BIG + (4 * (MARGIN_SMALL + ROW_HEIGHT)) + MARGIN_BIG;
    CGRect rect = CGRectMake(left, top, screenWidth - (2 * MARGIN_BIG), ROW_HEIGHT);
    _tipSlider = [[UISlider alloc] initWithFrame:rect];
    
    // These number values represent each slider position
    _tipRates = [[NSMutableArray alloc] init];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.00"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.10"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.12"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.15"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.20"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.25"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.30"]];
    [_tipRates addObject:[NSDecimalNumber decimalNumberWithString:@"0.50"]];
    
    // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[_tipRates count] - 1);
    _tipSlider.maximumValue = numberOfSteps;
    _tipSlider.minimumValue = 0;

    // As the slider moves it will continously call the -valueChanged:
    _tipSlider.continuous = YES; // NO makes it call only once you let go
    [_tipSlider addTarget:self
               action:@selector(sliderValueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    // add
    [self addSubview:_tipSlider];
    
    return _tipSlider;
}

- (void)sliderValueChanged:(UISlider *)sender {
    
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(_tipSlider.value + 0.5);
    [_tipSlider setValue:index animated:NO];
    
    // set tip rate
    NSDecimalNumber* tipRate = _tipRates[index];
    [_tipCalculator setTipRate:tipRate];
    
    // update UI
    NSString* rateAsText = [[tipRate decimalNumberByMultiplyingByPowerOf10:2] stringValue];
    rateAsText = [rateAsText stringByAppendingString:@" %"];
    [_tipRateLabel setText:rateAsText];
    [_tipLabel setText:[TipCalculator decimalAsCurrency:[_tipCalculator getTipAmount]]];
    [_totalLabel setText:[TipCalculator decimalAsCurrency:[_tipCalculator getGrandTotal]]];
}

- (void)createButtons
{
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // calculate locatio s
    CGFloat halfSize = (screenWidth - 2 * MARGIN_BIG - MARGIN_SMALL) / 2.0f;
    CGFloat top = statusBarHeight + MARGIN_BIG + (5 * (MARGIN_SMALL + ROW_HEIGHT)) + 2 * MARGIN_BIG;
    
    // create BACK button
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set number on the button
    [backButton setTitle:@"BACK" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor whiteColor]];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // register onTap event
    [backButton addTarget:self
                   action:@selector(backButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // set frame for the button
    backButton.frame = CGRectMake(MARGIN_BIG, top, halfSize, BUTTON_HEIGHT);
    
    // add it to the view
    [self addSubview:backButton];
    
    // create DONE button
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set number on the button
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor whiteColor]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // register onTap event
    [doneButton addTarget:self
                     action:@selector(doneButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    // set frame for the button
    doneButton.frame = CGRectMake(MARGIN_BIG + halfSize + MARGIN_SMALL, top, halfSize, BUTTON_HEIGHT);
    
    // add it to the view
    [self addSubview:doneButton];
}

-(void)backButtonTapped:(id)sender
{
    _tipCalculator.tipRate = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    [self removeFromSuperview];
}

-(void)doneButtonTapped:(id)sender
{
    exit(0);
}

@end