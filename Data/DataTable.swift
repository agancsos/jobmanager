//
//  DataTable.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class DataTable {
    private var tableName : String = "";
    private var tableRows : [DataRow] = [];
    
    
    /// This is the default constructor
    public init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter rows: Rows
    public init(rows : [DataRow]) {
        self.tableRows = rows;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - name: Name of the table
    ///   - rows: Rows in the table
    public init(name : String, rows : [DataRow]) {
        self.tableName = name;
        self.tableRows = rows;
    }
    
    public func getTableName() -> String {
        return self.tableName;
    }
    
    public func getRows() -> [DataRow] {
        return self.tableRows;
    }
    
    
    /// This method adds a new row to the table
    ///
    /// - Parameter row: Row to add
    public func addRow(row : DataRow) {
        self.tableRows.append(row);
    }
}
