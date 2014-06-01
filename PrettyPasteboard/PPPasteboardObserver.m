//
//  PPPasteboardObserver.m
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPPasteboardObserver.h"

static const char *kQueueLabel = "org.okolodev.PrettyPasteboard";
static const useconds_t kPollInterval = 250000;

typedef
NS_ENUM(unsigned char, PPPasteboardObserverState)
{
    PPPasteboardObserverStateDisabled,
    PPPasteboardObserverStateEnabled,
    PPPasteboardObserverStatePaused
};

@implementation PPPasteboardObserver
{
    NSMutableSet *_subscribers;
    dispatch_queue_t _serialQueue;
    PPPasteboardObserverState _state;
    NSInteger _changeCount;
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    _serialQueue = dispatch_queue_create(kQueueLabel, NULL);
    _changeCount = -1;
    _subscribers = [NSMutableSet new];
    return self;
}

- (void)dealloc
{
    [self stopObserving];
    [self removeSubscribers];
}

#pragma mark - Observing

- (void)startObserving
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self changeState:PPPasteboardObserverStateEnabled];
        [self observerLoop];
    });
}

- (void)stopObserving
{
    [self changeState:PPPasteboardObserverStateDisabled];
}

- (void)pauseObserving
{
    [self changeState:PPPasteboardObserverStatePaused];
}

- (void)continueObserving
{
    if (_state == PPPasteboardObserverStatePaused) {
        _changeCount = self.pasteboard.changeCount;
        _state = PPPasteboardObserverStateEnabled;
    }
}

- (void)changeState:(PPPasteboardObserverState)state
{
    dispatch_sync(_serialQueue, ^{
        _state = state;
    });
}

- (BOOL)isEnabled
{
    return _state == PPPasteboardObserverStateEnabled;
}

- (void)observerLoop
{
    while ([self isEnabled]) {
        usleep(kPollInterval);
        BOOL countEquals = _changeCount == self.pasteboard.changeCount;
        if (countEquals) {
            continue;
        }
        _changeCount = self.pasteboard.changeCount;

        [self pasteboardContentChanged];
    }
}

- (NSPasteboard *)pasteboard
{
    if (!_pasteboard) {
        _pasteboard = [NSPasteboard generalPasteboard];
    }
    
    return _pasteboard;
}

- (void)pasteboardContentChanged
{
    [self pauseObserving];
    for (id<PPPasteboardObserverSubscriber> subscriber in _subscribers) {
        [subscriber pasteboardChanged:self.pasteboard];
    }
    [self continueObserving];
}

#pragma mark - Subscribers

- (void)addSubscriber:(id<PPPasteboardObserverSubscriber>)subscriber
{
    [_subscribers addObject:subscriber];
}

- (void)removeSubscriber:(id<PPPasteboardObserverSubscriber>)subscriber
{
    [_subscribers removeObject:subscriber];
}

- (void)removeSubscribers
{
    [_subscribers removeAllObjects];
}

@end
