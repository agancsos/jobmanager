//
//  DataColumn.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class DataColumn {
    private var columnName  : String = "";
    private var columnValue : String = "";
    
    
    /// This is the default constructor
    public init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter v: Value of the column
    public init(v : String) {
        self.columnValue = v;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - n: Name of the column
    ///   - v: Value of the column
    public init(n : String, v : String) {
        self.columnName = n;
        self.columnValue = v;
    }
    
    public func getName() -> String {
        return self.columnName;
    }
    
    public func getValue() -> String {
        return self.columnValue;
    }
}
