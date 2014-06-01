//
//  PPPasteboardJSONHandler.m
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPPasteboardJSONHandler.h"

@implementation PPPasteboardJSONHandler

- (void)pasteboardChanged:(NSPasteboard *)pasteboard
{
    NSLog(@"%@", [pasteboard stringForType:NSPasteboardTypeString]);
}

@end
