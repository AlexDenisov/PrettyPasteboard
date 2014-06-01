//
//  PPAppDelegate.m
//  PrettyPasteboard
//
//  Created by AlexDenisov on 5/31/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPPasteboardObserver.h"
#import "PPPasteboardJSONHandler.h"

@implementation PPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusBarIcon = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    self.statusBarIcon.title = @"PP";
    
    NSMenu *menu = [NSMenu new];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusBarIcon.menu = menu;
    
    self.observer = [PPPasteboardObserver new];
    
    PPPasteboardJSONHandler *jsonHandler = [PPPasteboardJSONHandler new];
    [self.observer addSubscriber:jsonHandler];
    [self.observer startObserving];
}

@end
