//
//  TipCalculator.h
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#ifndef EasyTip_TipCalculator_h
#define EasyTip_TipCalculator_h

#import <UIKit/UIKit.h>

@interface TipCalculator : NSObject
{
}

@property (nonatomic, readwrite) NSDecimalNumber* billAmount;
@property (nonatomic, readwrite) NSDecimalNumber* tipRate;

- (id) init;
- (NSDecimalNumber*) getTipAmount;
- (NSDecimalNumber*) getGrandTotal;
+ (NSString*)decimalAsCurrency:(NSDecimalNumber*)decimalVal;


@end

#endif
