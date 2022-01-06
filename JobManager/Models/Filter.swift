//
//  Filter.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/14/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class Filter : Item {
    public var keywords       : [String] = [];
    public var location       : String = "NEW JERSEY";
    public var compensation   : Double = 0.0;
    public var distance       : Double = 0.0;
    public var jobType        : [JobType] = [];
    public var tech           : [String] = [];
    
    override public init() {
        super.init();
    }
    
    public init(json: String = "") {
        super.init();
        if (json != "") {
            self.parseJson(a: json);
        }
    }
        
    private func parseJson(a: String) {
        let jsonObject : JsonObject = JsonObject(json: a);
        self.keywords = (jsonObject.getKey(key: "keywords") as? String)?.components(separatedBy: ";") ?? [];
        self.tech = (jsonObject.getKey(key: "tech") as? String)?.components(separatedBy: ";") ?? [];
        self.location = (jsonObject.getKey(key: "location") as? String) ?? "";
        self.level = (jsonObject.getKey(key: "level") as? String) ?? "";
        self.compensation = Double((jsonObject.getKey(key: "compensation") as? String) ?? "0.0") ?? 0.0;
        self.distance = Double((jsonObject.getKey(key: "distance") as? String) ?? "0.0") ?? 0.0;
        let rawJobTypes = (jsonObject.getKey(key: "jobType") as? String) ?? "";
        for cursor : String in (rawJobTypes.components(separatedBy: ";")) {
            self.jobType.append(JobType.init(rawValue: Int(cursor) ?? 0) ?? .NONE);
        }
    }
    
    public func toJsonString() -> String {
        var result = "{";
        result += "\"keywords\":\"\(self.keywords.joined(separator: ";"))\"";
        result += ",\"location\":\"\(self.location)\"";
        result += ",\"compensation\":\"\(self.compensation)\"";
        result += ",\"distance\":\"\(self.distance)\"";
        var jobTypes : String = "";
        var i = 0;
        for type : JobType in self.jobType {
            if (i > 0) {
                jobTypes += ";";
            }
            jobTypes += "\(type)";
            i += 1;
        }
        result += ",\"jobType\":\"\(jobTypes)\"";
        result += ",\"tech\":\"\(self.tech.joined(separator: ";"))\"";
        result += ",\"level\":\"\(self.level)\"";
        result += "}";
        return result;
    }
}
