//
//  Company.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class Company : Item , NSCopying {
    public var companyId         : Int   = -1;
    public var name              : String = "Default";
    public var street            : String = "";
    public var city              : String = "";
    public var state             : String = "";
    public var country           : String = "";
    public var description       : String = "";
    public var industry          : String = "";
    public var employees         : Int    = 0;
    public var rating            : Float  = 0.0;
    public var isPublic          : Bool   = false;
    public var lastUpdatedDate   : String = "";
    public var applicantEndpoint : String = "";
    
    override public init() {
        super.init();
    }
    
    public init(json: String) {
        if let data = json.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any];
                companyId = Int(obj?["id"] as! String) ?? -1;
                employees = Int(obj?["employees"] as! String) ?? 0;
                rating = Float(obj?["rating"] as? String ?? "0.0") ?? 0.0;
                isPublic = (Int(obj?["isPublic"] as! String) ?? 0) == 1 ? true : false;
                name = (obj?["name"] as! String);
                street = (obj?["street"] as! String);
                city = (obj?["city"] as! String);
                state = (obj?["state"] as! String);
                country = (obj?["country"] as! String);
                description = (obj?["description"] as! String);
                industry = (obj?["industry"] as! String);
                applicantEndpoint = (obj?["applicantEndpoint"] as! String);
            }
            catch {
            }
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self;
    }
    
    public func toJsonString() -> String {
        var result : String = "{";
        result += "\"id\":\"\(self.companyId)\"";
        result += ",\"name\":\"\(self.name)\"";
        result += ",\"street\":\"\(self.street)\"";
        result += ",\"city\":\"\(self.city)\"";
        result += ",\"state\":\"\(self.state)\"";
        result += ",\"country\":\"\(self.country)\"";
        result += ",\"description\":\"\(self.description)\"";
        result += ",\"industry\":\"\(self.industry)\"";
        result += ",\"employees\":\"\(self.employees)\"";
        result += ",\"rating\":\"\(self.rating)\"";
        result += ",\"isPublic\":\"\(self.isPublic ? "1" : "0")\"";
        result += ",\"lastUpdatedDate\":\"\(self.lastUpdatedDate)\"";
        result += ",\"applicantEndpoint\":\"\(self.applicantEndpoint)\"";
        result += "}";
        return result;
    }
}
