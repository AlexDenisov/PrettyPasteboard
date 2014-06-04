//
//  PPPasteboardObserver.swift
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/3/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

import Foundation
import Cocoa

enum PPPasteboardObserverState {
    case Disabled
    case Enabled
    case Paused
}

class PPPasteboardObserver : NSObject {
    var pasteboard : NSPasteboard = NSPasteboard.generalPasteboard()
    
    var subscribers : NSMutableSet = NSMutableSet()
    var serialQueue : dispatch_queue_t = dispatch_queue_create("org.okolodev.PrettyPasteboard", nulDev)
    var changeCount : Int = -1
    var state : PPPasteboardObserverState = PPPasteboardObserverState.Disabled
    
    init() {
        
    }
    
    deinit {
        self.stopObserving()
        self.removeSubscribers()
    }
    
    // Observing
    
    func startObserving() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.changeState(PPPasteboardObserverState.Enabled)
            self.observerLoop()
        });
    }
    
    func stopObserving() {
        self.changeState(PPPasteboardObserverState.Disabled)
    }

    func pauseObserving() {
        self.changeState(PPPasteboardObserverState.Paused)
    }
    
    func continueObserving() {
        if (self.state == PPPasteboardObserverState.Paused) {
            self.changeCount = self.pasteboard.changeCount;
            self.state = PPPasteboardObserverState.Enabled
        }
    }
    
    func observerLoop() {
        while self.isEnabled() {
            usleep(250000)
            var countEquals = self.changeCount == self.pasteboard.changeCount
            if countEquals {
                continue
            }
            
            self.changeCount = self.pasteboard.changeCount
            self.pasteboardContentChanged()
        }
    }
    
    func pasteboardContentChanged() {
        self.pauseObserving()
        for anySubscriber : AnyObject in self.subscribers {
            if let subscriber = anySubscriber as? protocol<PPPasteboardObserverSubscriber> {
                subscriber.pasteboardChanged(self.pasteboard)
            }
        }
        self.continueObserving()
    }
    
    func changeState(newState: PPPasteboardObserverState) {
        dispatch_sync(self.serialQueue, { () -> Void in
            self.state = newState;
        });
    }
    
    func isEnabled() -> Bool {
        return self.state == PPPasteboardObserverState.Enabled;
    }
    
    // Subscribers
    
    func addSubscriber(subscriber: PPPasteboardObserverSubscriber) {
        self.subscribers.addObject(subscriber)
    }
    
    func removeSubscribers() {
        self.subscribers.removeAllObjects()
    }

}
