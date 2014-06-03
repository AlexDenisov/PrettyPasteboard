//
//  PPPasteboardJSONHandler.swift
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/3/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

import Foundation
import Cocoa

class PPPasteboardJSONHandler : NSObject, PPPasteboardObserverSubscriber {
    
    init() {
    
    }
    
    func pasteboardChanged(pasteboard: NSPasteboard) {
        var pasteboardContent = pasteboard.dataForType(NSPasteboardTypeString)
        var json : AnyObject = NSJSONSerialization.JSONObjectWithData(pasteboardContent, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var newjson = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setData(newjson, forType: NSPasteboardTypeString)
    }
}
