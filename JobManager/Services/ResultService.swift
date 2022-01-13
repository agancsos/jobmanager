//
//  CompanyService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/11/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common
import Data

public final class ResultService {
    private static var dataService       : DataService = DataService.getInstance();
    private static var serverResults     : [Result] = [];
    
    private static func updateFromServer(profile: Profile) {
        RestHelper.getResults(profile: profile, { rsp in
            
        });
    }
    
    private static func updateFromServer(company: Company) {
        RestHelper.getResults(company: company, { rsp in
            
        });
    }
    
    private static func updateToServer(result: Result) {
        RestHelper.updateResult(result: result, { rsp in
            
        });
    }
    
    public static func getResult(id : Int) -> Result {
        let result  : Result = Result();
        let rawResult = dataService.serviceQuery(query: "SELECT * FROM RESULT WHERE RESULT_ID = '\(id)'");
        if (rawResult.getRows().count == 1) {
            let row = rawResult.getRows()[0];
            for column : DataColumn in row.getColumns() {  
                switch (column.getName().replacingOccurrences(of: "RESULT_", with: "").lowercased()) {
                    case "id":
                        result.resultId = Int(column.getValue()) ?? -1;
                        break;
                    case "profile_id":
                        result.profile = ProfileService.getProfile(id: Int(column.getValue()) ?? -1);
                        break;
                    case "min_years_needed":
                        result.minYearsNeeded = Int(column.getValue()) ?? -1;
                        break;
                    case "company_id":
                        result.company = CompanyService.getCompany(id: Int(column.getValue()) ?? -1);
                        break;
                    case "base_endpoint":
                        result.baseEndpoint = EndpointService.getEndpoint(id: Int(column.getValue()) ?? -1);
                        break;
                    case "state":
                        result.state = ResultState.init(rawValue: Int(column.getValue()) ?? -1) ?? .NEW;
                        break;
                    case "code":
                        result.code = column.getValue();
                        break;
                    case "last_updated_date":
                        result.lastUpdatedDate = column.getValue();
                        break;
                    case "poasted_date":
                        result.postedDate = column.getValue();
                        break;
                    case "title":
                        result.title = column.getValue();
                        break;
                    case "description":
                        result.description = column.getValue();
                        break;
                    case "required":
                        result.required = column.getValue();
                        break;
                    case "optional":
                        result.optional = column.getValue();
                        break;
                    case "benefits":
                        result.benefits = column.getValue();
                        break;
                    case "applied":
                        result.applied = column.getValue() == "0" ? false : true;
                        break;
                    case "otherdetails":
                        result.otherDetails = column.getValue();
                        break;
                    case "source_endpoint":
                        result.sourceEndpoint = column.getValue();
                        break;
                    default:
                        break;
                }
            }
        }
        return result;
    }
    
    public static func getResults(a : Profile = Profile()) -> [Result] {
        var result : [Result] = [];
        updateFromServer(profile: a);
        var query : String = "SELECT * FROM RESULT";
        if (a.profileId != -1) {
            query = "SELECT * FROM RESULT WHERE PROFILE_ID = '\(a.profileId)'";
        }
        for row : DataRow in dataService.serviceQuery(query: query).getRows() {
            result.append(getResult(id: Int(row.getColumn(name: "RESULT_ID")?.getValue() ?? "0") ?? 0));
        }
        
        let group = DispatchGroup();
        for r in result {
            if (RestHelper.results[r.code] == nil) {
                group.enter();
                RestHelper.addResult(result: r, { rsp in
                    group.leave();
                });
                group.wait();
            }
        }
        return result;
    }
    
    public static func getResults(a : Company = Company()) -> [Result] {
        var result : [Result] = [];
        updateFromServer(company: a);
        var query : String = "SELECT * FROM RESULT";
        if (a.companyId != -1) {
            query = "SELECT * FROM RESULT WHERE COMPANY_ID = '\(a.companyId)'";
        }
        for row : DataRow in dataService.serviceQuery(query: query).getRows() {
            result.append(getResult(id: Int(row.getColumn(name: "RESULT_ID")?.getValue() ?? "0") ?? 0));
        }
        
        let group = DispatchGroup();
        for r in result {
            if (RestHelper.results[r.code] == nil) {
                group.enter();
                RestHelper.addResult(result: r, { rsp in
                    group.leave();
                });
                group.wait();
            }
        }
        return result;
    }
    
    public static func addResult(a : Result) {
        let sql = "INSERT INTO RESULT (PROFILE_ID, POSTED_DATE, RESULT_APPLIED, RESULT_TITLE, RESULT_DESCRIPTION, RESULT_REQUIRED, RESULT_OPTIONAL, RESULT_BENEFITS, RESULT_OTHERDETAILS, RESULT_MIN_YEARS_NEEDED, RESULT_SOURCE_ENDPOINT, RESULT_BASE_ENDPOINT, RESULT_STATE, RESULT_CODE, COMPANY_ID) VALUES ('\(a.profile.profileId)','\(a.postedDate)','0','\(a.title)','\(a.description)','\(a.required)','\(a.optional)','\(a.benefits)','\(a.otherDetails)','\(a.minYearsNeeded)','\(a.sourceEndpoint)','\(a.baseEndpoint.endpointId)','\(a.state.rawValue)', '\(a.code)', '\(a.company.companyId)')";
        _ = dataService.runServiceQuery(query: sql);
        updateToServer(result: a);
    }
    
    public static func markApplied(a : Result) {
        a.state = .APPLIED;
        a.applied = true;
        updateResult(a: a);
        RestHelper.markApplied(result: a, { rsp in
            
        });
    }
    
    public static func markOferred(a : Result) {
        a.state = .OFFERED;
        updateResult(a: a);
        RestHelper.markOffered(result: a, { rsp in
            
        });
    }
    
    public static func markAccepted(a : Result) {
        a.state = .ACCEPTED;
        updateResult(a: a);
        RestHelper.markAccepted(result: a, { rsp in
            
        });
    }
    
    public static func markRead(a : Result) {
        a.state = .REVIEWED;
        updateResult(a: a);
        RestHelper.markRead(result: a, { rsp in
            
        });
    }
    
    public static func markRejected(a : Result) {
        a.state = .REJECTED;
        updateResult(a: a);
        RestHelper.markRejected(result: a, { rsp in
            
        });
    }
    
    public static func updateResult(a: Result) {
        let sql = "UPDATE RESULT SET COMPANY_ID = '\(a.company.companyId)', PROFILE_ID = '\(a.profile.profileId)', POSTED_DATE = '\(a.postedDate)', RESULT_APPLIED = '0', RESULT_TITLE = '\(a.title)', RESULT_DESCRIPTION = '\(a.description)', RESULT_REQUIRED = '\(a.required)', RESULT_OPTIONAL = '\(a.optional)', RESULT_BENEFITS = '\(a.benefits)', RESULT_OTHERDETAILS = '\(a.otherDetails)', RESULT_MIN_YEARS_NEEDED = '\(a.minYearsNeeded)', RESULT_CODE='\(a.code)',RESULT_APPLIED = '\(a.applied ? "1" : "0")', RESULT_SOURCE_ENDPOINT = '\(a.sourceEndpoint)', RESULT_BASE_ENDPOINT = '\(a.baseEndpoint.endpointId)', RESULT_STATE = '\(a.state.rawValue)', LAST_UPDATED_DATE = CURRENT_TIMESTAMP WHERE RESULT_ID = '\(a.resultId)'";
        _ = dataService.runServiceQuery(query: sql);
        updateToServer(result: a);
    }
}
