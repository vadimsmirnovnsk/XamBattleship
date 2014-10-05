//
//  BSInviteFriendVC.m
//  XamBattleship
//
//  Created by Wadim on 20/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSInviteFriendVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#pragma mark - BSPeoplePicker Interface

@interface BSPeoplePicker : ABPeoplePickerNavigationController
@end


#pragma mark - BSPeoplePicker Implementation

@implementation BSPeoplePicker

- (instancetype)init
{
    if (self = [super init]) {
        [self.navigationBar setHidden:YES];
        [self.view setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

@end


#pragma mark - BSInviteFriendVC Extansion

@interface BSInviteFriendVC () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) BSPeoplePicker *addressBookController;
@property (nonatomic, strong) NSMutableArray *arrContactsData;

- (void)showAddressBook;

@end


#pragma mark - BSInviteFriendVC Implementation

@implementation BSInviteFriendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite Friends";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ABPeoplePickerNavigationControllerDelegate Protocol
- (void)showAddressBook
{
    self.addressBookController = [[BSPeoplePicker alloc]init];
    self.addressBookController.peoplePickerDelegate = self;
    [self addChildViewController:self.addressBookController];
    [self.addressBookController didMoveToParentViewController:self];
    [self.view addSubview:self.addressBookController.view];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)
    peoplePicker{
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
        initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]
        forKeys:@[@"firstName", @"lastName", @"mobileNumber",
        @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    CFTypeRef generalCFObject;
    
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue
                forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    if (ABPersonHasImageData(person)) {
        NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        
        [contactInfoDict setObject:contactImageData forKey:@"image"];
    }
    
    
    if (_arrContactsData == nil) {
        _arrContactsData = [[NSMutableArray alloc] init];
    }
    [_arrContactsData addObject:contactInfoDict];
    
    NSLog(@"%@", _arrContactsData);
    
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
    
}


@end
