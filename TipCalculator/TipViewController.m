//
//  TipViewController.m
//  TipCalculator
//
//  Created by Venkata Reddy on 9/6/14.
//  Copyright (c) 2014 Venkata Reddy. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"


@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *splitSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipPerLabel;
@property (weak, nonatomic) IBOutlet UISlider *tipPerSlider;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

- (IBAction)onTap:(id)sender;
- (IBAction)onTextInputChange:(id)sender;
- (IBAction)onTipPerChange:(id)sender;
- (IBAction)onSplitChange:(id)sender;
- (void)updateValues;
- (void)openKeyBoard;
- (NSString*)getLocalCurrencySymbol;
- (IBAction)onDownBtn:(id)sender;
- (IBAction)onUpBtn:(id)sender;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"viewDidLoad");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    // Do any additional setup after loading the view from its nib.
    self.billTextField.text = self.getLocalCurrencySymbol;
    self.billTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    [self openKeyBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
        [self.view endEditing:YES];
}

- (IBAction)onTextInputChange:(id)sender {
    if ( [@""  isEqual: self.billTextField.text]){
        self.billTextField.text = self.getLocalCurrencySymbol;
    }
    [self updateValues];
}

- (IBAction)onTipPerChange:(id)sender {
    int tipPer = self.tipPerSlider.value;
    self.tipPerLabel.text = [NSString stringWithFormat:@"%d%@",tipPer,@"%"];
    [self updateValues];
}

- (IBAction)onSplitChange:(id)sender {
    int splitCount = self.splitSlider.value;
    self.splitCountLabel.text = [NSString stringWithFormat:@"%d",splitCount];
    [self updateValues];
}

- (void)updateValues{
    float billAmount = [self getBillAmount:self.billTextField.text];
    int tipPer = self.tipPerSlider.value;
    int splitCount = self.splitSlider.value;
    
    float tipAmount = (billAmount * tipPer)/100;
    float totalAmount = billAmount + tipAmount;
    float splitAmount = totalAmount/splitCount;
    // update the labels
    self.tipLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,totalAmount];
    self.splitLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,splitAmount];
}

-(void)onSettingsButton{
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

// Remove currency symbol and get the total bill amount
- (float)getBillAmount:(NSString*)amount {
    NSMutableString *billAmount = [NSMutableString stringWithString:amount];
    [billAmount deleteCharactersInRange: [billAmount rangeOfString: self.getLocalCurrencySymbol]];
    return [billAmount floatValue];
}

- (void)openKeyBoard{
    [self.billTextField becomeFirstResponder];
}

- (NSString*)getLocalCurrencySymbol{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *currencySymbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    //NSLog(@"Currency Symbol : %@",currencySymbol);
    return currencySymbol;
}

- (IBAction)onDownBtn:(id)sender {
    float billAmount = [self getBillAmount:self.billTextField.text];
    float roundedTotal = floor([self getBillAmount:self.totalLabel.text]);
    float tipAmount = roundedTotal - billAmount;
    
    int splitCount = self.splitSlider.value;
    float splitAmount = roundedTotal/splitCount;
    
    // update the labels
    self.tipLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,roundedTotal];
    self.splitLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,splitAmount];
}

- (IBAction)onUpBtn:(id)sender {
    float billAmount = [self getBillAmount:self.billTextField.text];
    float roundedTotal = ceil([self getBillAmount:self.totalLabel.text]);
    float tipAmount = roundedTotal - billAmount;
    
    int splitCount = self.splitSlider.value;
    float splitAmount = roundedTotal/splitCount;
    
    // update the labels
    self.tipLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,roundedTotal];
    self.splitLabel.text = [NSString stringWithFormat:@"%@%0.2f", self.getLocalCurrencySymbol,splitAmount];
}

- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"view will appear");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int defTipPer = [prefs integerForKey:@"defTipPer"];
    int defSplitCount = [prefs integerForKey:@"defSplitCount"];

    // To handle intial load
    if (defTipPer == 0 && defSplitCount == 0){            defTipPer = 15;
        defSplitCount = 2;
    }
    if (defTipPer != self.tipPerSlider.value){
        self.tipPerSlider.value = defTipPer;
        self.tipPerLabel.text = [NSString stringWithFormat:@"%d%@",defTipPer,@"%"];
    }
    
    if (defSplitCount != self.splitSlider.value){
        self.splitSlider.value = defSplitCount;
        self.splitCountLabel.text = [NSString stringWithFormat:@"%d",defSplitCount];
    }
    [self updateValues];
}
@end
