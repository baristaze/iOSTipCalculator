//
//  TipCalculator.m
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipCalculator.h"

@implementation TipCalculator
{
    NSDecimalNumber* _billAmount;
    NSDecimalNumber* _tipRate;
}

- (void) setBillAmount:(NSDecimalNumber*)theBillAmount
{
    _billAmount = theBillAmount;
}

- (void) setTipRate:(NSDecimalNumber*)theTipRate
{
    _tipRate = theTipRate;
}

- (NSDecimalNumber*) getTipAmount
{
    return [_billAmount decimalNumberByMultiplyingBy:_tipRate];
}

- (NSDecimalNumber*) getGrandTotal
{
    return [_billAmount decimalNumberByAdding:[self getTipAmount]];
}

- (id) init
{
    if(self = [super init]){
        _billAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:0.0f] decimalValue]];
        _tipRate = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:0.0f] decimalValue]];
    }
    return self;
}

+ (NSString*)decimalAsCurrency:(NSDecimalNumber*)decimalVal
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString* numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[decimalVal floatValue]]];
    return numberAsString;
}

@end