//
//  ProfileViewController.h
//  Twitter Profile
//
//  Created by Veeral Patel on 05-02-13.
//  Copyright (c) 2013 Veeral Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "FXLabel.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *profileImageView;
    
    IBOutlet UITextField *topInput;
    IBOutlet UITextField *bottomInput;
    
    IBOutlet FXLabel *topText;
    IBOutlet FXLabel *bottomText;
    
    IBOutlet UISlider *textSize;
    
    IBOutlet UILabel *usernameLabel;

    NSString *username;
}

@property (nonatomic, retain) NSString *username;
@property (strong, nonatomic) IBOutlet UITextField *topInput;
@property (strong, nonatomic) IBOutlet UITextField *bottomInput;
@property (strong, nonatomic) IBOutlet FXLabel *topText;
@property (strong, nonatomic) IBOutlet FXLabel *bottomText;
@property (strong, nonatomic) IBOutlet UISlider *textSize;


@end
