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

public class ProfileService {
    private static var dataService       : DataService = DataService.getInstance();
    
    public static func getProfile(id : Int) -> Profile {
        let result  : Profile = Profile();
        let rawResult = dataService.serviceQuery(query: "SELECT * FROM PROFILE WHERE PROFILE_ID = '\(id)'");
        if (rawResult.getRows().count == 1) {
            let row = rawResult.getRows()[0];
            for column : DataColumn in row.getColumns() {
                switch (column.getName().replacingOccurrences(of: "PROFILE_", with: "").lowercased()) {
                    case "id":
                        result.profileId = Int(column.getValue()) ?? -1;
                        break;
                    case "name":
                        result.name = column.getValue();
                        break;
                    case "filter":
                        result.filter = Filter(json: column.getValue());
                        break;
                    case "last_updated_date":
                        result.lastUpdatedDate = column.getValue();
                        break;
                    default:
                        break;
                }
            }
        }
        return result;
    }
    
    public static func getProfiles() -> [Profile] {
        var result : [Profile] = [];
        for row : DataRow in dataService.serviceQuery(query: "SELECT * FROM PROFILE").getRows() {
            result.append(getProfile(id: Int(row.getColumn(name: "PROFILE_ID")?.getValue() ?? "0") ?? 0));
        }
        return result;
    }
    
    public static func addProfile(a : Profile) {
        let sql = "INSERT INTO PROFILE (PROFILE_NAME, PROFILE_FILTER) VALUES ('\(a.name)','\(a.filter.toJsonString())')";
        _ = dataService.runServiceQuery(query: sql);
    }
    
    public static func updateProfile(a: Profile) {
        let sql = "UPDATE PROFILE SET PROFILE_NAME = '\(a.name)', PROFILE_FILTER = '\(a.filter.toJsonString())' WHERE PROFILE_ID = '\(a.profileId)'";
        _ = dataService.runServiceQuery(query: sql);
    }
    
    public static func removeEndpoint(a : Int) {
        _ = dataService.runServiceQuery(query: "DELETE FROM PROFILE WHERE PROFILE_ID = '\(a)'")
    }
}
