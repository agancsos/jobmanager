//
//  EndpointService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/14/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common
import Data

public final class EndpointService {
    private static var dataService       : DataService = DataService.getInstance();
    
    public static func getEndpoint(id : Int) -> Endpoint {
        let result  : Endpoint = Endpoint();
        let rawResult = dataService.serviceQuery(query: "SELECT * FROM ENDPOINT WHERE ENDPOINT_ID = '\(id)'");
        if (rawResult.getRows().count == 1) {
            let row = rawResult.getRows()[0];
            for column : DataColumn in row.getColumns() {
                switch (column.getName().replacingOccurrences(of: "ENDPOINT_", with: "").lowercased()) {
                    case "id":
                        result.endpointId = Int(column.getValue()) ?? -1;
                        break;
                    case "profile_id":
                        result.profile = ProfileService.getProfile(id: Int(column.getValue()) ?? 0);
                        break;
                    case "origin":
                        result.origin = column.getValue();
                        break;
                    case "base_url":
                        result.baseUrl = column.getValue();
                        break;
                    case "param_location":
                        result.paramLocation = column.getValue();
                        break;
                    case "param_keywords":
                        result.paramKeywords = column.getValue();
                        break;
                    case "param_distance":
                        result.paramDistance = column.getValue();
                        break;
                    case "param_tech":
                        result.paramTech = column.getValue();
                        break;
                    case "param_compensation":
                        result.paramCompensation = column.getValue();
                        break;
                    case "param_jobtype":
                        result.paramJobType = column.getValue();
                        break;
                    default:
                        break;
                }
            }
        }
        return result;
    }
    
    public static func getEndpoints(a: Profile = Profile()) -> [Endpoint] {
        var result : [Endpoint] = [];
        var query : String = "SELECT * FROM ENDPOINT";
        if (a.profileId > 0) {
            query = "SELECT * FROM ENDPOINT WHERE PROFILE_ID = '\(a.profileId)'";
        }
        for row : DataRow in dataService.serviceQuery(query: query).getRows() {
            result.append(getEndpoint(id: Int(row.getColumn(name: "ENDPOINT_ID")?.getValue() ?? "0") ?? 0));
        }
        return result;
    }
    
    public static func addEndpoint(a : Endpoint) {
        let sql = "INSERT INTO ENDPOINT (ENDPOINT_ORIGIN,PROFILE_ID, ENDPOINT_BASE_URL,ENDPOINT_PARAM_LOCATION,ENDPOINT_PARAM_KEYWORDS, ENDPOINT_PARAM_DISTANCE,ENDPOINT_PARAM_TECH,ENDPOINT_PARAM_COMPENSATION,ENDPOINT_PARAM_JOBTYPE) VALUES ('\(a.origin)', '\(a.profile.profileId)', '\(a.baseUrl)','\(a.paramLocation)','\(a.paramKeywords)','\(a.paramDistance)','\(a.paramTech)','\(a.paramCompensation)','\(a.paramJobType)')";
        _ = dataService.runServiceQuery(query: sql);
    }
    
    public static func removeEndpoint(a : Int) {
        _ = dataService.runServiceQuery(query: "DELETE FROM ENDPOINT WHERE ENDPOINT_ID = '\(a)'")
    }
}
