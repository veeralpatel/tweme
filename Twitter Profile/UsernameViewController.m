//
//  UsernameViewController.m
//  Twitter Profile
//
//  Created by Veeral Patel on 05-02-13.
//  Copyright (c) 2013 Veeral Patel. All rights reserved.
//

#import "UsernameViewController.h"
#import "ProfileViewController.h"

@interface UsernameViewController ()

@end

@implementation UsernameViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfileViewController *profileViewController = [segue destinationViewController];
    [profileViewController setUsername:usernameTextfield.text];
}

@end
