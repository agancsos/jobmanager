//
//  Message.swift
//  HASLIb
//
//  Created by Abel Gancsos on 5/3/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public class Message : Item {
    private var messageId       : Int;
    private var text            : String;
    private var level           : TraceLevel;
    private var category        : TraceCategory;
    private var lastUpdatedDate : String;
    
    public init(id : Int = -1) {
        self.messageId = id;
        self.text = "";
        self.level = .NONE;
        self.category = .NONE;
        self.lastUpdatedDate = "";
    }
    
    public init(json : String) {
        let jsonObject : JsonObject = JsonObject(json: json);
        self.messageId = Int(jsonObject.getKey(key: "id") as! String) ?? -1;
        self.text = jsonObject.getKey(key: "text") as! String;
        self.level = TraceLevel.init(rawValue: Int(jsonObject.getKey(key: "level") as! String) ?? 0) ?? .NONE;
        self.category = TraceCategory.init(rawValue: Int(jsonObject.getKey(key: "category") as! String) ?? 0) ?? .NONE;
        self.lastUpdatedDate = jsonObject.getKey(key: "lastUpdatedDate") as! String;
    }
    
    public func toJsonString() -> String {
        var result = "{";
        result += "\"id\":\"\(self.messageId)\",";
        result += "\"level\":\"\(self.level.rawValue)\",";
        result += "\"category\":\"\(self.category.rawValue)\",";
        result += "\"text\":\"\(self.text)\",";
        result += "\"lastUpdatedDate\":\"\(self.lastUpdatedDate)\"";
        result += "}";
        return result;
    }
    
    public func getId() -> Int { return self.messageId; }
    public func getText() -> String { return self.text; }
    public func getLevel() -> TraceLevel { return self.level; }
    public func getCategory() -> TraceCategory { return self.category; }
    public func getLastUpdatedDate() -> String { return self.lastUpdatedDate; }
    public func setText(a : String) { self.text = a; }
    public func setLevel(a : TraceLevel) { self.level = a; }
    public func setCategory(a : TraceCategory) { self.category = a; }
    public func setLastUpdatedDate(a : String) { self.lastUpdatedDate = a; }
}
