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

public final class CompanyService {
    private static var dataService       : DataService = DataService.getInstance();
    
    private static func updateFromServer() {
        RestHelper.getCompanies({rsp in
            
        });
    }
    
    private static func updateToServer(company: Company) {
        RestHelper.updateCompany(company: company, { rsp in
            
        })
    }
    
    public static func getCompany(id : Int) -> Company {
        let result  : Company = Company();
        result.companyId = id;
        let rawResult = dataService.serviceQuery(query: "SELECT * FROM COMPANY WHERE COMPANY_ID = '\(id)'");
        if (rawResult.getRows().count == 1) {
            let row = rawResult.getRows()[0];
            for column : DataColumn in row.getColumns() {
                switch (column.getName().replacingOccurrences(of: "COMPANY_", with: "").lowercased()) {
                    case "name":
                        result.name = column.getValue();
                        break;
                    case "street":
                        result.street = column.getValue();
                        break;
                    case "city":
                        result.city = column.getValue();
                        break;
                    case "state":
                        result.state = column.getValue();
                        break;
                    case "country":
                        result.country = column.getValue();
                        break;
                    case "description":
                        result.description = column.getValue();
                        break;
                    case "industry":
                        result.industry = column.getValue();
                        break;
                    case "employees":
                        result.employees = Int(column.getValue()) ?? -1;
                        break;
                    case "rating":
                        result.rating = Float(column.getValue()) ?? 0.0;
                        break;
                    case "ispublic":
                        result.isPublic = (column.getValue() == "1" ? true : false);
                        break;
                    case "applicant_endpoint":
                        result.applicantEndpoint = column.getValue();
                        break;
                    case "lastupdateddate":
                        result.lastUpdatedDate = column.getValue();
                        break;
                    default:
                        break;
                }
            }
        }
        return result;
    }
    
    public static func getCompanies() -> [Company] {
        var result : [Company] = [];
        updateFromServer();
        for row : DataRow in dataService.serviceQuery(query: "SELECT * FROM COMPANY ORDER BY COMPANY_RATING DESC, UPPER(COMPANY_NAME) ASC").getRows() {
            result.append(getCompany(id: Int(row.getColumn(name: "COMPANY_ID")?.getValue() ?? "0") ?? 0));
        }
        let group = DispatchGroup();
        for company in result {
            group.enter();
            if (RestHelper.companies[company.name] == nil) {
                group.enter();
                RestHelper.addCompany(company: company, { rsp in
                    group.leave();
                });
                group.leave();
            }
            group.wait();
        }
        return result;
    }
    
    public static func hasCompany(a : String) -> Bool {
        return dataService.serviceQuery(query: "SELECT 1 FROM COMPANY WHERE COMPANY_NAME = '\(a)'").getRows().count > 0;
    }
    
    public static func addCompany(a : Company) {
        if (!hasCompany(a: a.name)) {
            _ = dataService.runServiceQuery(query: "INSERT INTO COMPANY (COMPANY_NAME, COMPANY_STREET, COMPANY_CITY, COMPANY_STATE, COMPANY_COUNTRY, COMPANY_DESCRIPTION, COMPANY_INDUSTRY, COMPANY_EMPLOYEES, COMPANY_RATING, COMPANY_ISPUBLIC, COMPANY_APPLICANT_ENDPOINT) VALUES ('\(a.name)','\(a.street)','\(a.city)','\(a.state)','\(a.country)','\(a.description)','\(a.industry)','\(a.employees)','\(a.rating)','\(a.isPublic ? "1" : "0")', '\(a.applicantEndpoint)')");
            updateToServer(company: a);
        }
    }
    
    public static func updateCompany(a : Company) {
        _ = dataService.runServiceQuery(query: "UPDATE COMPANY SET COMPANY_NAME = '\(a.name)', COMPANY_STREET = '\(a.street)', COMPANY_CITY = '\(a.city)', COMPANY_STATE = '\(a.state)', COMPANY_COUNTRY = '\(a.country)', COMPANY_DESCRIPTION = '\(a.description)', COMPANY_INDUSTRY = '\(a.industry)', COMPANY_EMPLOYEES = '\(a.employees)', COMPANY_RATING = '\(a.rating)', COMPANY_ISPUBLIC = '\(a.isPublic ? "1" : "0")', COMPANY_APPLICANT_ENDPOINT = '\(a.applicantEndpoint)', LAST_UPDATED_DATE = CURRENT_TIMESTAMP WHERE COMPANY_ID = '\(a.companyId)'");
        updateToServer(company: a);
    }
    
    public static func getEndpoints() -> [Company] {
        var result : [Company] = [];
        for row : DataRow in dataService.serviceQuery(query: "SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_APPLICANT_ENDPOINT <> '' ORDER BY COMPANY_NAME ASC").getRows() {
            result.append(getCompany(id: Int(row.getColumn(name: "COMPANY_ID")?.getValue() ?? "0") ?? 0));
        }
        return result;
    }
}
