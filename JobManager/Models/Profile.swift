//
//  Profile.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/16/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation

public final class Profile : Item, NSCopying {
    public var profileId       : Int = -1;
    public var name            : String = "";
    public var lastUpdatedDate : String = "";
    public var filter          : Filter = Filter();
    
    override public init() {
        
    }
    
    public func copyWithZone(zone : NSZone) -> Any? {
        return nil;
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self;
    }
}
