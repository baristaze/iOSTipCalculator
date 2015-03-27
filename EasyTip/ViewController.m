//
//  ViewController.m
//  EasyTip
//
//  Created by Baris Taze on 3/26/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // create tip calculator
    _tipCalculator = [[TipCalculator alloc] init];
    
    // create BillView
    _billView = [[BillView alloc] initWith:_tipCalculator];
    
    // set the view
    [self setView:_billView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
