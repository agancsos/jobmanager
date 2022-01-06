//
//  Item.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/10/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation

public class Item {
    
    public init() {
        
    }
    
    public func getProperties() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label };
    }
    
    public func getValues() -> [Any] {
        return Mirror(reflecting: self).children.compactMap { $0.value };
    }
}
