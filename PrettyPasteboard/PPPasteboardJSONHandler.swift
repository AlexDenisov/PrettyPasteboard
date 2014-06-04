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
        
        var error : NSError?
        var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(pasteboardContent, options: NSJSONReadingOptions.AllowFragments, error: &error)
        
        if let error = error {
            return
        }
        
        var newjson = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setData(newjson, forType: NSPasteboardTypeString)
    }
}
