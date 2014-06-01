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
    [self initStatusBar];
    [self initMenu];
    [self initObserver];
}

- (void)initStatusBar
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusBarIcon = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    self.statusBarIcon.title = @"PP";
}

- (void)initMenu
{
    NSMenu *menu = [NSMenu new];
    NSMenuItem *enableItem = [menu addItemWithTitle:@"Enabled" action:@selector(changeState:) keyEquivalent:@""];
    [enableItem setState:1];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"About" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusBarIcon.menu = menu;
}

- (void)initObserver
{
    self.observer = [PPPasteboardObserver new];
    
    PPPasteboardJSONHandler *jsonHandler = [PPPasteboardJSONHandler new];
    [self.observer addSubscriber:jsonHandler];
    [self.observer startObserving];
}

- (void)changeState:(NSMenuItem *)sender
{
    if (sender.state) {
        [self.observer stopObserving];
    } else {
        [self.observer startObserving];
    }
    
    sender.state = !sender.state;
}

@end
