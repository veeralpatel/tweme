//
//  ProfileViewController.m
//  Twitter Profile
//
//  Created by Veeral Patel on 05-02-13.
//  Copyright (c) 2013 Veeral Patel. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize username;

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
    
    topText = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    topText.textColor = [UIColor whiteColor];
    topText.numberOfLines = 2;
    topText.innerShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    topText.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    topText.layer.shadowOffset = CGSizeMake(0, 2);
    topText.textAlignment = NSTextAlignmentCenter;
    topText.layer.shadowColor = [UIColor blackColor].CGColor;
    topText.layer.shadowOpacity = 1.0;
    topText.backgroundColor = [UIColor clearColor];
    [self->profileImageView addSubview:topText];
    
    bottomText = [[FXLabel alloc] initWithFrame:CGRectMake(0, 218, 320, 100)];
    bottomText.textColor = [UIColor whiteColor];
    bottomText.numberOfLines = 2;
    bottomText.innerShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    bottomText.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    bottomText.layer.shadowOffset = CGSizeMake(0, 2);
    bottomText.textAlignment = NSTextAlignmentCenter;
    bottomText.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomText.layer.shadowOpacity = 1.0;
    bottomText.backgroundColor = [UIColor clearColor];
    [self->profileImageView addSubview:bottomText];
    
    [self getInfo];
}

-(IBAction)saveMeme
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(profileImageView.frame.size);
    }
    
	[profileImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}

-(IBAction)sliderValueChanged:(UISlider *)sender
{
    NSInteger val = lround(sender.value);
    topText.font = [UIFont fontWithName:@"Impact" size:val];
    bottomText.font = [UIFont fontWithName:@"Impact" size:val];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.topInput.text);
    NSLog(@"You entered %@",self.bottomInput.text);
    
    topText.text = [self.topInput.text uppercaseString];
    bottomText.text = [self.bottomInput.text uppercaseString];
    
    [self.topInput resignFirstResponder];
    [self.bottomInput resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) getInfo
{
    // Request access to the Twitter accounts
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){ 
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                        
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];

                            // Filter the preferred data
                            
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            
                            usernameLabel.text= [NSString stringWithFormat:@"@%@",screen_name];

                            NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                            
                            // Get the profile image in the original resolution
                            
                            profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                            [self getProfileImageForURLString:profileImageStringURL];

                        }
                    });
                }];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}

- (void) getProfileImageForURLString:(NSString *)urlString;
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    profileImageView.image = [UIImage imageWithData:data];
}



@end
