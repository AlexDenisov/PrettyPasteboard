//
//  PPPasteboardObserver.h
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPPasteboardObserverSubscriber.h"

@interface PPPasteboardObserver : NSObject

@property (nonatomic, strong) NSPasteboard *pasteboard;

- (void)startObserving;
- (void)stopObserving;

- (void)addSubscriber:(id<PPPasteboardObserverSubscriber>)subscriber;
- (void)removeSubscriber:(id<PPPasteboardObserverSubscriber>)subscriber;

@end
