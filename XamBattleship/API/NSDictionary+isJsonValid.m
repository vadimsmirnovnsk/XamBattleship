//
//  NSDictionary+isJsonValid.m
//  XamBattleship
//
//  Created by Vadim Smirnov on 02/10/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "NSDictionary+isJsonValid.h"
#import "BSServerAPIController.h"

@implementation NSDictionary (isJsonValid)

- (BOOL)isJsonValid
{
    if (self[kEventField] && self[kDataField]) {
    // It's looks like a valid JSON, let's check what it contains
        if ([self[kEventField] isEqualToString:kEventFieldParameterSignIn]) {
            // Looks like "signin" event
            if ((self[kDataField][kDataFieldParameterName]) &&
                (self[kDataField][kDataFieldParameterToken]) &&
                (self[kDataField][kDataFieldParameterResult])) {
                // It's really correct "signin" event
                return YES;
            }
            else return NO;
        }
        else return NO;
    }
    else return NO;
}

@end
