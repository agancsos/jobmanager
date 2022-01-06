//
//  DataRow.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class DataRow {
    private var rowIndex   : Int = 0;
    private var rowColumns : [DataColumn] = [];
    
    
    /// This is the default constructor
    public init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter columns: Columns
    public init(columns : [DataColumn]) {
        self.rowIndex = self.rowColumns.count + 1;
        self.rowColumns = columns;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - index: Row index
    ///   - columns: Row columns
    public init(index : Int, columns : [DataColumn]) {
        self.rowIndex = index;
        self.rowColumns = columns;
    }
    
    public func getRowIndex() -> Int {
        return self.rowIndex;
    }
    
    public func getColumns() -> [DataColumn] {
        return self.rowColumns;
    }
	
	public func getColumn(name : String) -> DataColumn? {
		for cursor : DataColumn in rowColumns {
			if(cursor.getName() == name) {
				return cursor;
			}
		}
		return nil;
	}
    
    
    /// This method helps build the row by adding a new column
    ///
    /// - Parameter column: Column
    public func addColumn(column : DataColumn) {
		for cursor : DataColumn in rowColumns {
			if(cursor.getName() == column.getName()) {
				return;
			}
		}
        self.rowColumns.append(column);
    }
}
