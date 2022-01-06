//
//  Result.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/11/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class Result : Item{
    public var resultId        : Int = -1;
    public var profile         : Profile = Profile();
    public var code            : String = "";
    public var company         : Company = Company();
    public var lastUpdatedDate : String = "";
    public var postedDate      : String = "";
    public var applied         : Bool = false;
    public var title           : String = "";
    public var description     : String = "";
    public var required        : String = "";
    public var optional        : String = "";
    public var benefits        : String = "";
    public var otherDetails    : String = "";
    public var minYearsNeeded  : Int = 0;
    public var sourceEndpoint  : String = "";
    public var baseEndpoint    : Endpoint = Endpoint();
    public var state           : ResultState = .NEW;
    
    override public init() {
        super.init();
    }
    
    public init(json: String) {
        if let data = json.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any];
                resultId = Int(obj?["id"] as! String) ?? -1;
                code = obj?["code"] as! String;
                minYearsNeeded = Int(obj?["minYears"] as! String) ?? 0;
                state = ResultState(rawValue: Int(obj?["state"] as! String) ?? 0)!;
                applied = (Int(obj?["applied"] as! String) ?? 0) == 1 ? true : false;
                title = (obj?["title"] as! String);
                required = (obj?["required"] as! String);
                optional = (obj?["optional"] as! String);
                benefits = (obj?["benefits"] as! String);
                company = Company(json: obj?["company"] as! String);
                otherDetails = (obj?["otherDetails"] as! String);
                description = (obj?["description"] as! String);
                sourceEndpoint = (obj?["sourceEndpoint"] as! String);
                lastUpdatedDate = (obj?["lastUpdatedDate"] as! String);
            }
            catch {
            }
        }
    }
    
    public func toJsonString() -> String {
        var result : String = "{";
        result += "\"id\":\"\(self.resultId)\"";
        result += ",\"code\":\"\(self.code)\"";
        result += ",\"minYears\":\"\(self.minYearsNeeded)\"";
        result += ",\"state\":\"\(self.state.rawValue)\"";
        result += ",\"applied\":\"\(self.applied ? "1" : "0")\"";
        result += ",\"title\":\"\(self.title)\"";
        result += ",\"description\":\"\(self.description)\"";
        result += ",\"required\":\"\(self.required)\"";
        result += ",\"optional\":\"\(self.optional)\"";
        result += ",\"benefits\":\"\(self.benefits)\"";
        result += ",\"otherDetails\":\"\(self.otherDetails)\"";
        result += ",\"lastUpdatedDate\":\"\(self.lastUpdatedDate)\"";
        result += ",\"sourceEndpoint\":\"\(self.sourceEndpoint)\"";
        result += ",\"company\":\(self.company.toJsonString())";
        result += "}";
        return result;
    }
}
