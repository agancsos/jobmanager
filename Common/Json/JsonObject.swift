//
//  JsonObject.swift
//  Common
//
//  Created by Abel Gancsos on 5/3/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation

public class JsonObject {
    private var container : NSObject?;
    
    public init(json: String) {
        do {
           try self.container = JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSObject;
        }
        catch {
        
        }
    }
    
    public func getKey(key: String) -> Any {
        if(self.container != nil) {
            if(self.container != nil) {
                return (self.container?.value(forKey: key) as? String) ?? "";
            }
        }
        return "";
    }
}
