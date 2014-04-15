//
//  secondViewController.m
//  iosapp
//
//  Created by William on 14/11/13.
//  Copyright (c) 2013 William. All rights reserved.
//
/*
 presentedViewController
 The view controller that is presented by this view controller, or one of its ancestors in the view controller hierarchy. (read-only)
 
 @property(nonatomic, readonly) UIViewController *presentedViewController
 Availability
 Available in iOS 5.0 and later.
 Related Sample Code
 AlternateViews
 Declared In
 UIViewController.h
 presentingViewController
 The view controller that presented this view controller. (read-only)
 
 @property(nonatomic, readonly) UIViewController *presentingViewController
 Discussion
 If the view controller that received this message is presented by another view controller, this property holds the view controller that is presenting it. If the view controller is not presented, but one of its ancestors is being presented, this property holds the view controller presenting the nearest ancestor. If neither the view controller nor any of its ancestors are being presented, this property holds nil. */

#import "secondViewController.h"
#import "mainViewController.h"

@interface secondViewController ()

@end

@implementation secondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _mes.text=((mainViewController *)self.presentingViewController).senddata.text;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showmes:(id)sender {
    
    NSString *str =[[NSString alloc] initWithFormat:@"Hello:%@",_input.text];
    [_mes setText:str];
    [_input resignFirstResponder];
     
}


    


@end
