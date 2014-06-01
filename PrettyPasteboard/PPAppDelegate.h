//
//  PPAppDelegate.h
//  PrettyPasteboard
//
//  Created by AlexDenisov on 5/31/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

@class PPPasteboardObserver;

@interface PPAppDelegate : NSObject
    <NSApplicationDelegate>

@property (nonatomic, strong) NSStatusItem *statusBarIcon;
@property (nonatomic, strong) PPPasteboardObserver *observer;

@end
