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

@interface ViewController ()<MXClientChatDelegate>
@property (nonatomic, readwrite, strong) NSMutableArray *chatList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMoxtraAccount:nil];
}

- (void)initializeMoxtraAccount:(id)sender
{
    // Initialize user using unique user identity
    MXUserIdentity *useridentity = [[MXUserIdentity alloc] init];
    useridentity.userIdentityType = kUserIdentityTypeIdentityUniqueID;
    useridentity.userIdentity = @"JohnDoe";
    
    __weak ViewController *weakSelf = self;
    [[Moxtra sharedClient] initializeUserAccount: useridentity orgID: nil firstName: @"John" lastName: @"Doe" avatar: nil devicePushNotificationToken: nil withTimeout:0.0 success: ^{
        
        NSLog(@"Initialize user successfully");
        [weakSelf fetchChatList];   //get chat list
    } failure: ^(NSError *error) {
        
        if (error.code == MXClientErrorUserAccountAlreadyExist)
        {
            NSLog(@"There is a user exist, if you want to initialize with another user please unlink current user firstly");
            [weakSelf fetchChatList];   //get chat list
        }
        
        NSLog(@"Initialize user failed, %@", [NSString stringWithFormat:@"error code [%ld] description: [%@] info [%@]", (long)[error code], [error localizedDescription], [[error userInfo] description]]);
    }];
    
    // Set delegate
    [Moxtra sharedClient].delegate = self;
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

- (void)fetchChatList
{
    NSArray *chatListArray = [[Moxtra sharedClient] getChatSessionArray];
    self.chatList = [NSMutableArray arrayWithArray:chatListArray];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"MXChatListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MXChatSession *chatGroup = [self.chatList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",chatGroup.topic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - MXClientChatDelegate
- (void)onChatSessionUpdated:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.tableView reloadData];
    }
}

- (void)onChatSessionCreated:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.chatList addObject:chatSession];
        [self.tableView reloadData];
    }
}
- (void)onChatSessionDeleted:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.chatList removeObject:chatSession];
        [self.tableView reloadData];
    }
}

@end
