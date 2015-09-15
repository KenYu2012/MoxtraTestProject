//
//  ViewController.m
//  Moxie
//
//  Created by KenYu on 9/14/15.
//  Copyright (c) 2015 Moxtra. All rights reserved.
//

#import "ViewController.h"
#import "Moxtra.h"

#define MOXTRASDK_TEST_USER1_UniqueID       JohnDoe         //dummy user1
#define MOXTRASDK_TEST_USER2_UniqueID       KevinRichardson //dummy user2

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initializeMoxtraAccount:(id)sender
{
    // Initialize user using unique user identity
    MXUserIdentity *useridentity = [[MXUserIdentity alloc] init];
    useridentity.userIdentityType = kUserIdentityTypeIdentityUniqueID;
    useridentity.userIdentity = @"JohnDoe";
    
    [[Moxtra sharedClient] initializeUserAccount: useridentity orgID: nil firstName: @"John" lastName: @"Doe" avatar: nil devicePushNotificationToken: nil withTimeout:0.0 success: ^{
        
        NSLog(@"Initialize user successfully");
    } failure: ^(NSError *error) {
        
        if (error.code == MXClientErrorUserAccountAlreadyExist)
            NSLog(@"There is a user exist, if you want to initialize with another user please unlink current user firstly");
        
        NSLog(@"Initialize user failed, %@", [NSString stringWithFormat:@"error code [%ld] description: [%@] info [%@]", (long)[error code], [error localizedDescription], [[error userInfo] description]]);
    }];
}

- (void)unlinkMoxtraAccount:(id)sender
{
    [[Moxtra sharedClient] unlinkAccount:^(BOOL success) {
        
        if (success)
            NSLog(@"Unlink user successfully");
        else
            NSLog(@"Unlink user failed");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
