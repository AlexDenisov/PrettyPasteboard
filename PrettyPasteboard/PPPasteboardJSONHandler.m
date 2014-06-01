//
//  PPPasteboardJSONHandler.m
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPPasteboardJSONHandler_Private.h"

@implementation PPPasteboardJSONHandler

- (instancetype)init
{
    self = [super init];
    self.jsonWriter = [SBJson4Writer new];
    self.jsonWriter.humanReadable = YES;
    return self;
}

- (void)pasteboardChanged:(NSPasteboard *)pasteboard
{
    NSData *pasteboardContent = [pasteboard dataForType:NSPasteboardTypeString];
    
    SBJson4ValueBlock valueBlock = ^(id obj, BOOL *ignored) {
        NSData *newContent = [self.jsonWriter dataWithObject:obj];
        [pasteboard declareTypes:@[ NSPasteboardTypeString ] owner:nil];
        [pasteboard setData:newContent forType:NSPasteboardTypeString];
    };
    
    SBJson4ErrorBlock errorHandler = ^(NSError *error) {
        // just ignore
    };
    
    id parser = [SBJson4Parser parserWithBlock:valueBlock
                                allowMultiRoot:NO
                               unwrapRootArray:NO
                                  errorHandler:errorHandler];
    
    [parser parse:pasteboardContent];
}

@end
