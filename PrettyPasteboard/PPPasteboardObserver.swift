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
    case PPPasteboardObserverStateDisabled
    case PPPasteboardObserverStateEnabled
    case PPPasteboardObserverStatePaused
}

class PPPasteboardObserver : NSObject {
    var pasteboard : NSPasteboard = NSPasteboard.generalPasteboard()
    
    var subscribers : NSMutableSet = NSMutableSet()
    var serialQueue : dispatch_queue_t = dispatch_queue_create("org.okolodev.PrettyPasteboard", nulDev)
    var changeCount : Int = -1
    var state : PPPasteboardObserverState = PPPasteboardObserverState.PPPasteboardObserverStateDisabled
    
    init() {
        
    }
    
    deinit {
        self.stopObserving()
        self.removeSubscribers()
    }
    
    // Observing
    
    func startObserving() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.changeState(PPPasteboardObserverState.PPPasteboardObserverStateEnabled)
            self.observerLoop()
        });
    }
    
    func stopObserving() {
        self.changeState(PPPasteboardObserverState.PPPasteboardObserverStateDisabled)
    }

    func pauseObserving() {
        self.changeState(PPPasteboardObserverState.PPPasteboardObserverStatePaused)
    }
    
    func continueObserving() {
        if (self.state == PPPasteboardObserverState.PPPasteboardObserverStatePaused) {
            self.changeCount = self.pasteboard.changeCount;
            self.state = PPPasteboardObserverState.PPPasteboardObserverStateEnabled
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
        return self.state == PPPasteboardObserverState.PPPasteboardObserverStateEnabled;
    }
    
    // Subscribers
    
    func addSubscriber(subscriber: PPPasteboardObserverSubscriber) {
        self.subscribers.addObject(subscriber)
    }
    
    func removeSubscribers() {
        self.subscribers.removeAllObjects()
    }

}
