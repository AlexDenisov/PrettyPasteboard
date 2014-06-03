//
//  PPPasteboardObserverSubscriber.swift
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/3/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

import Foundation
import Cocoa

@objc protocol PPPasteboardObserverSubscriber: NSObjectProtocol {
    
    func pasteboardChanged(pasteboard: NSPasteboard)
    
}
