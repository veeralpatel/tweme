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

@interface ProfileViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *profileImageView;
    
    IBOutlet UITextField *topInput;
    IBOutlet UITextField *bottomInput;
    

    
    IBOutlet UILabel *usernameLabel;

    NSString *username;
}

@property (nonatomic, retain) NSString *username;
@property (strong, nonatomic) IBOutlet UITextField *topInput;
@property (strong, nonatomic) IBOutlet UITextField *bottomInput;

@end
