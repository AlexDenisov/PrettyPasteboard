//
//  PPPasteboardJSONHandler_Private.h
//  PrettyPasteboard
//
//  Created by AlexDenisov on 6/1/14.
//  Copyright (c) 2014 Railsware. All rights reserved.
//

#import "PPPasteboardJSONHandler.h"
#import <SBJson/SBJson4.h>

@interface PPPasteboardJSONHandler ()

@property (nonatomic, strong) SBJson4Writer *jsonWriter;

@end
