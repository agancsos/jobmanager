//
//  DataService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Data
import Common

public final class DataService {
    private var connection      : DataConnection;
    private static var instance : DataService?;
    private var lock            : NSLock = NSLock();
    
    private init() {
        var path = (Helper.store.getProperty(key: "Datasource") as? String) ?? "\(SR.basePath)/jobs.jm";
        #if os(macOS)
        if (path == "") {
            path = "\(SR.basePath)/jobs.jm";
        }
        #else
        path = "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString)/jobs.jm";
        #endif
        self.connection = DataConnectionSQLite(source: path);
        
        if (Helper.store.getProperty(key: "SkipCreateSchema") as! String != "1") {
            self.createSchema();
        }
    }
    
    public static func getInstance() -> DataService {
        if (instance == nil) {
            instance = DataService();
        }
        return instance!;
    }
    
    public func updatePath(path : String) {
        connection = DataConnectionSQLite(source: path, error: "");
    }
    
    private func createSchema() {
        let queries : [String] = [
            "CREATE TABLE IF NOT EXISTS FLAG (FLAG_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, FLAG_NAME CHARACTER, FLAG_VALUE CHARACTER, LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            
            "CREATE TABLE IF NOT EXISTS MESSAGE (MESSAGE_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, MESSAGE_LEVEL INTEGER, MESSAGE_CATEGORY INTEGER, MESSAGE_TEXT CHARACTER, LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            
            "CREATE TABLE IF NOT EXISTS COMPANY (COMPANY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, COMPANY_NAME CHARACTER, COMPANY_STREET CHARACTER, COMPANY_CITY CHARACTER, COMPANY_STATE CHARACTER, COMPANY_COUNTRY CHARACTER, COMPANY_DESCRIPTION CHARACTER, COMPANY_INDUSTRY CHARACTER, COMPANY_EMPLOYEES INTEGER DEFAULT '0', COMPANY_RATING REAL DEFAULT '0.0', COMPANY_ISPUBLIC INTEGER DEFAULT '0', COMPANY_APPLICANT_ENDPOINT CHARACTER, LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            
            "CREATE TABLE IF NOT EXISTS PROFILE (PROFILE_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, PROFILE_NAME CHARACTER NOT NULL, PROFILE_FILTER CHARACTER default '', LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            
            "CREATE TABLE IF NOT EXISTS COMPANY_TAG(COMPANY_ID INTEGER NOT NULL, TAG_LABEL CHARACTER NOT NULL, LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID))",
                                    
            "CREATE TABLE IF NOT EXISTS RESULT (RESULT_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, PROFILE_ID INTEGER NOT NULL, RESULT_CODE CHARACTER, COMPANY_ID INTEGER, POSTED_DATE TIMESTAMP, RESULT_APPLIED INTEGER DEFAULT '0', RESULT_TITLE CHARACTER, RESULT_DESCRIPTION CHARACTER, RESULT_REQUIRED CHARACTER, RESULT_OPTIONAL CHARACTER, RESULT_BENEFITS CHARACTER, RESULT_OTHERDETAILS CHARACTER, RESULT_MIN_YEARS_NEEDED INTEGER DEFAULT '0', RESULT_SOURCE_ENDPOINT CHARACTER, RESULT_BASE_ENDPOINT INTEGER, RESULT_STATE INTEGER DEFAULT '0', LAST_UPDATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (RESULT_BASE_ENDPOINT) REFERENCES ENDPOINT(ENDPOINT_ID), FOREIGN KEY (PROFILE_ID) REFERENCES PROFILE(PROFILE_ID))",
        ];
        
        for query : String in queries {
            _ = self.runServiceQuery(query: query);
        }
        
        // Just to document the fix for COMPANY.COMPANY_RATING column:
        // 1. alter table COMPANY rename TO COMPANY2
        // 2. <create-query>
        // 3. INSERT INTO COMPANY SELECT COMPANY_ID, COMPANY_NAME, COMPANY_STREET, COMPANY_CITY, COMPANY_STATE, COMPANY_COUNTRY, COMPANY_DESCRIPTION, COMPANY_INDUSTRY, COMPANY_EMPLOYEES, COMPANY_RATING, COMPANY_ISPUBLIC, COMPANY_APPLICANT_ENDPOINT, LAST_UPDATED_DATE  FROM COMPANY2
        // 4. drop table COMPANY2

    }
    
    private func loadFlags() {
        for key in Helper.store.getKeys() {
            let value = Helper.store.getProperty(key: key);
            if ((value as? String) != nil) {
                if (self.serviceQuery(query: "SELECT 1 FROM FLAG WHERE FLAG_NAME = '\(key)'").getRows().count == 0) {
                    _ = self.runServiceQuery(query: "INSERT INTO FLAG (FLAG_NAME, FLAG_VALUE, LAST_UPDATED_DATE) VALUES ('\(key)', '\(value as! String)', CURRENT_TIMESTAMP)")
                }
                else {
                    _ = self.runServiceQuery(query: "UPDATE FLAG SET FLAG_NAME = '\(key)', FLAG_VALUE = '\(value as! String)', LAST_UPDATED_DATE = CURRENT_TIMESTAMP WHERE FLAG_NAME = '\(key)'");
                }
            }
        }
    }
        
    public func runServiceQuery(query: String) -> Bool {
        var result = false;
        self.lock.lock();
        result = self.connection.runQuery(sql: query);
        self.lock.unlock();
        return result;
    }
    
    public func serviceQuery(query : String) -> DataTable {
        var result = DataTable();
        self.lock.lock();
        result = self.connection.query(sql: query);
        self.lock.unlock();
        return result;
    }
    
    public func auditMessage(level : TraceLevel, category : TraceCategory, message : String) {
        _ = self.runServiceQuery(query: "INSERT INTO MESSAGE (MESSAGE_LEVEL, MESSAGE_CATEGORY, MESSAGE_TEXT) VALUES ('\(level.rawValue)', '\(category.rawValue)', '\(message)')");
    }
    
    public func getMessages() -> [Message] {
        var result : [Message] = [];
        let rawResults = self.serviceQuery(query: "SELECT * FROM MESSAGE ORDER BY LAST_UPDATED_DATE DESC");
        for row : DataRow in rawResults.getRows() {
            let tempMessage = Message(id : Int(row.getColumn(name: "MESSAGE_ID")!.getValue()) ?? -1);
            tempMessage.setText(a: row.getColumn(name: "MESSAGE_TEXT")?.getValue() ?? "");
            tempMessage.setLevel(a: TraceLevel.init(rawValue: Int(row.getColumn(name: "MESSAGE_LEVEL")?.getValue() ?? "") ?? 0) ?? TraceLevel.INFORMATIONAL);
            tempMessage.setCategory(a: TraceCategory.init(rawValue: Int(row.getColumn(name: "MESSAGE_CATEGORY")?.getValue() ?? "") ?? 0) ?? TraceCategory.MISC);
            tempMessage.setLastUpdatedDate(a: row.getColumn(name: "LAST_UPDATED_DATE")?.getValue() ?? "");
            result.append(tempMessage);
        }
        return result;
    }
}
