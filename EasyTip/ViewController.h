//
//  ViewController.h
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipCalculator.h"
#import "BillView.h"

@interface ViewController : UIViewController
{
    @private
    TipCalculator* _tipCalculator;
    BillView* _billView;
}

@end

