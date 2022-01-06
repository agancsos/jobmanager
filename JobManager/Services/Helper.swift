//
//  Helper.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class Import {
    private var companies : [Company] = [];
    private var positions : [Result] = [];
    public init(raw: String) {
        if let data = raw.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any];
                for rawCompany in obj!["companies"] as! [String] {
                    self.companies.append(Company(json: rawCompany));
                }
                for rawResult in obj!["results"] as! [String] {
                    self.positions.append(Result(json: rawResult));
                }
            }
            catch {
            }
        }
    }
    public init(companies: [Company], results: [Result]) {
        self.companies = companies;
        self.positions = results;
    }
    public func toJsonString() -> String {
        var result = "{";
        result += "\"companies\":[";
        for i in 0..<self.companies.count {
            if (i > 0) {
                result += ",";
            }
            result += self.companies[i].toJsonString();
        }
        result += "]";
        result += ",\"results\":[";
        for i in 0..<self.positions.count {
            if (i > 0) {
                result += ",";
            }
            result += self.positions[i].toJsonString();
        }
        result += "]";
        result += "}";
        return result;
    }
    
    public func importData() {
        for company in self.companies {
            CompanyService.addCompany(a: company);
        }
        for result in self.positions {
            ResultService.addResult(a: result);
        }
    }
    
    public func exportData() -> String {
        return SecurityService.getEncoded(a: toJsonString());
    }
}

public final class Helper {
    
    public static var traceLevel     : TraceLevel = .INFORMATIONAL;
    public static var store          : PropertyStore = RegistryPropertyStore(src: SR.settingsFilePath);
    public static var currentProfile : Profile = Profile();
    private static var dataService   : DataService = DataService.getInstance();
    public static var currentCompany : Company = Company();
    
    public static func initializeDirectories() {
        if (!SystemService.directoryExists(path: SR.basePath)) {
            do {
                try FileManager.default.createDirectory(atPath: SR.basePath, withIntermediateDirectories: true, attributes: nil);
            }
            catch {
                
            }
        }
        
        let value = Helper.store.getProperty(key: "traceLevel")
        if  ((value as! String) != "") {
            traceLevel = TraceLevel.init(rawValue: Int(value as! String) ?? 3)!;
        }
        
        if (dataService.serviceQuery(query: "SELECT 1 FROM PROFILE WHERE PROFILE_ID = '0'").getRows().count == 0) {
            _ = dataService.runServiceQuery(query: "INSERT INTO PROFILE (PROFILE_ID, PROFILE_NAME) VALUES ('0', 'Default')");
        }
    }
    
    public static func exportData() -> String {
        return Import(companies: CompanyService.getCompanies(), results: ResultService.getResults(a: Profile())).exportData();
    }
    
    public static func importData(raw: String) {
        let incoming : Import = Import(raw: SecurityService.getDecoded(a: raw));
        incoming.importData();
    }
    
    public static func updateDataService(path : String) {
        dataService.updatePath(path: path);
    }
}
