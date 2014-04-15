//
//  mainViewController.m
//  iosapp
//
//  Created by William on 14/11/13.
//  Copyright (c) 2013 William. All rights reserved.
//

#import "mainViewController.h"


@interface mainViewController ()
- (IBAction)Exit:(id)sender;

@end

@implementation mainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendmessage:(id)sender {
    /*
    NSString *str =[[NSString alloc] initWithFormat:@"Hellofromfirstview%@",_senddata.text];
     */
    
    //[((secondViewController *)self.presentingViewController).mes setText:str];
    //((secondViewController *)self.presentingViewController).mes.text=str;(
    /*
    _senddata.text=((secondViewController *)self.presentedViewController).mes.text;
   // [_senddata resignFirstResponder];
     */
    
}

- (IBAction)GoBack:(UIStoryboardSegue *)segue {
    
}

- (IBAction)GoBackFromThird:(UIStoryboardSegue *)segue {
    
}

    
- (IBAction)Exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];}
    @end
