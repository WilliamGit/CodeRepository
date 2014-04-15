//
//  mainViewController.h
//  iosapp
//
//  Created by William on 14/11/13.
//  Copyright (c) 2013 William. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "secondViewController.h"

@interface mainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *senddata;
- (IBAction)sendmessage:(id)sender;

- (IBAction)GoBack:(UIStoryboardSegue *)segue;
- (IBAction)GoBackFromThird:(UIStoryboardSegue *)segue;
@end
