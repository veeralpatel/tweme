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

    [self getInfo];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.topInput.text);
    
    topCaption.text = self.topInput.text;
    bottomCaption.text = self.bottomInput.text;
    
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
