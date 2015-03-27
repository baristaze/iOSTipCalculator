//
//  TipView.h
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#ifndef EasyTip_TipView_h
#define EasyTip_TipView_h

#import <UIKit/UIKit.h>
#import "TipCalculator.h"

@interface TipView : UIView
{
    @private
    TipCalculator* _tipCalculator;
    
    @private
    UILabel* _tipRateLabel;
    UILabel* _tipLabel;
    UILabel* _totalLabel;
    UISlider* _tipSlider;
    NSMutableArray* _tipRates;
}

- (id)initWith:(TipCalculator*) tipCalculator;

@end

#endif
