//
//  Data.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
public class DataConnection {
    internal var databaseSource   : String = "";
	internal var databaseHandler  : OpaquePointer? = nil;
	internal var statementHandler : OpaquePointer? = nil;
	internal var databaseUser     : String = "";
	internal var databasePass     : String = "";
	internal var databaseHost     : String = "";
	internal var databaseService  : String = "";
	internal var databasePort     : Int = 0;
	internal var dbaUser          : String = "";
	internal var dbaPass          : String = "";
	internal var name             : String = "";
	internal var errorTable       : String = "";
	internal var lastError        : String = "";

	
    
    /// This is the common constructor
    ///
    /// - Parameter source: Source for the data
	public init (source : String = "", error : String = "") {
        self.databaseSource = source;
		self.errorTable = error;
    }
    
    
    /// This method connects to the database
	private func connect() -> Bool { return false; }
    
    
    /// This method disconnects from the database
    private func disconnect() { }
    
    
    /// This method runs a query that doesn't audit if failure
    ///
    /// - Parameter sql: Query to run
    private func runSafeQuery(sql : String) { }
    
    
    /// This method runs a query against the database
    ///
    /// - Parameter sql: Query to run
    /// - Returns: True if successful, false if not
    public func runQuery(sql : String) -> Bool {
        return true;
    }
    
    
    /// This method retrieves data from the database
    ///
    /// - Parameter sql: Query to run
    /// - Returns: Collection of strings from the database
    public func query(sql : String) -> DataTable {
        let temp : DataTable = DataTable();
        return temp;
    }
    
    /// This method finds the rowid value in the provided query for the table row
    ///
    /// - Parameters:
    ///   - sql: Query to lookup
    ///   - tableRow: Row in the table
    /// - Returns: Row ID value in the database
    public func findRowID(sql : String,tableRow : NSInteger) -> NSInteger{ return 0; }
    
    /// This method retrieves the columns for the query
    ///
    /// - Parameter sql: Query to retrieve columns for
    /// - Returns: Names of the columns
    public func columns(sql : String) -> [String] {
        let temp : NSMutableArray = NSMutableArray();
        return ((temp as NSArray) as! [String]);
    }
	
	/// Getters and setters
	public func setDataSource(source : String) { self.databaseSource = source; }
    public func getDataSource() -> String { return self.databaseSource; }
    public func setUsername(username : String) { self.databaseUser = username; }
	public func getUsername() -> String { return self.databaseUser; }
	public func setPassword(password : String) { self.databasePass = password; }
	public func setDatabaseHost(host : String) { databaseHost = host; }
	public func getDatabaseHost() -> String { return databaseHost; }
	public func setDatabaseService(service : String) { databaseService = service; }
	public func getDatabaseService() -> String { return databaseService; }
	public func setDatabasePort(port : Int) { databasePort = port; }
	public func getDatabasePort() -> Int { return databasePort; }
	public func setDbaUser(user : String) { dbaUser = user; }
	public func getDbaUser() -> String { return dbaUser; }
	public func setDbaPass(pass : String) { dbaPass = pass; }
	public func getDbaPass() -> String { return dbaPass; }
	public func setName(name : String) { self.name = name; }
	public func getName() -> String { return name; }
	public func getProviderName() -> String { return ""; }
}
