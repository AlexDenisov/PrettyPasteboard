//
//  PPPasteboardObserverSubscriber.h
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

@protocol PPPasteboardObserverSubscriber
    <NSObject>

- (void)pasteboardChanged:(NSPasteboard *)pasteboard;

@end