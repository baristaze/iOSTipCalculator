//
//  BillView.h
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#ifndef EasyTip_BillView_h
#define EasyTip_BillView_h

#import <UIKit/UIKit.h>
#import "TipCalculator.h"

@interface BillView : UIView
{
    @private
    TipCalculator* _tipCalculator;
    
    @private
    NSDecimalNumber* _currentVal;
    
    @private
    UILabel* _billAmountLabel;
}

- (id)initWith:(TipCalculator*) tipCalculator;

@end

#endif
