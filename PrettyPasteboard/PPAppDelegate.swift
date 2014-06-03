//
//  PPAppDelegate.swift
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/3/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

import Foundation
import Cocoa

class PPAppDelegate : NSObject, NSApplicationDelegate {
    
    var statusBarIcon: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(NSSquareStatusItemLength))
    var pasteboardObserver: PPPasteboardObserver = PPPasteboardObserver()
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        self.statusBarIcon.title = "PP"
        
        initMenu()
        
        var jsonHandler = PPPasteboardJSONHandler()
        self.pasteboardObserver.addSubscriber(jsonHandler)
        self.pasteboardObserver.startObserving()
    }
    
    func initMenu() {
        var menu = NSMenu()
        var enableItem = NSMenuItem(title: "Enabled", action: Selector("changeState:"), keyEquivalent: "")
        enableItem.state = 1;
        
        menu.addItem(enableItem)
        menu.addItem(NSMenuItem.separatorItem());
        menu.addItemWithTitle("About", action: Selector("orderFrontStandardAboutPanel:"), keyEquivalent: "")
        menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "")
        
        self.statusBarIcon.menu = menu;
    }
    
    func changeState(sender: NSMenuItem) {
        if (sender.state != 0) {
            self.pasteboardObserver.stopObserving()
        } else {
            self.pasteboardObserver.startObserving()
        }
        
        sender.state = Int(!Bool(sender.state))
    }

}
