//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Venkata Reddy on 9/6/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UISlider *splitSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipPerLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitLabel;

- (IBAction)onTipPerChanged:(id)sender;
- (IBAction)onSplitChanged:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                self.title = @"Settings";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int defTipPer = [prefs integerForKey:@"defTipPer"];
    int defSplitCount = [prefs integerForKey:@"defSplitCount"];
    // To handle intial load
    if (defTipPer == 0 && defSplitCount == 0){            defTipPer = 15;
        defSplitCount = 2;
    }
    self.tipSlider.value = defTipPer;
    self.tipPerLabel.text = [NSString stringWithFormat:@"%d%@",defTipPer,@"%"];

    
    self.splitSlider.value = defSplitCount;
    self.splitLabel.text = [NSString stringWithFormat:@"%d%@",defSplitCount,@"%"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTipPerChanged:(id)sender {
    int tipPer = self.tipSlider.value;
    self.tipPerLabel.text = [NSString stringWithFormat:@"%d%@",tipPer,@"%"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:tipPer forKey:@"defTipPer"];
    
    int splitCount = self.splitSlider.value;
    [prefs setInteger:splitCount forKey:@"defSplitCount"];
}

- (IBAction)onSplitChanged:(id)sender {
    int splitCount = self.splitSlider.value;
    self.splitLabel.text = [NSString stringWithFormat:@"%d",splitCount];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:splitCount forKey:@"defSplitCount"];
    
    int tipPer = self.tipSlider.value;
    [prefs setInteger:tipPer forKey:@"defTipPer"];
}
@end
