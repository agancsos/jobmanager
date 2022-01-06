//
//  DataConnectionSQLite.swift
//
//  Created by Abel Gancsos on 3/1/19.
//  Copyright © 2019 Abel Gancsos. All rights reserved.
//

import Foundation
public class DataConnectionSQLite : DataConnection {
	let lockObject : Any = 1;
	
	override public init (source : String = "", error : String = "") {
		super.init(source: source, error: error);
	}
		
	private func connect() -> Bool {
		do{
			if(sqlite3_open_v2(databaseSource ,&databaseHandler, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK){
				return true;
			}
		}
		return false;
	}
	
	private func disconnect() {
 		do {
			sqlite3_close_v2(databaseHandler);
		}
	}
	
	
	private func runSafeQuery(sql : String) {
		var safeQuery2 : String = sql;
		safeQuery2 = safeQuery2.replacingOccurrences(of: "'", with: "''");
		do{
			var queryHandler : OpaquePointer? = nil;
			if(sqlite3_prepare_v2(databaseHandler, safeQuery2 , -1, &queryHandler, nil) == SQLITE_OK){
				if(sqlite3_step(queryHandler) == SQLITE_DONE){
				}
				sqlite3_finalize(queryHandler);
			}
			else{
				#if DEBUG
					print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
				#endif
				lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
			}
		}
	}
	
	
	override public func runQuery(sql : String) -> Bool {
		var result : Bool = false;
		var queryHandler : OpaquePointer? = nil;
		if(connect()){
			do{
				if(sqlite3_prepare_v2(databaseHandler, sql, -1, &queryHandler, nil) == SQLITE_OK){
                    if(sqlite3_step(queryHandler) == SQLITE_DONE){
						result = true;
					}
					else{
                        #if DEBUG
                            print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
                        #endif
						if(errorTable != ""){
							//runSafeQuery(sql: String(format: "insert into %@ (%@_command_text,%@_error_text) values ('%@','%@')", errorTable,errorTable,errorTable,sql,String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!));
						}
					}
				}
				else{
					#if DEBUG
						print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
					#endif
					lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
				}
				sqlite3_finalize(queryHandler);
				disconnect();
			}
		}
		return result;
	}
	
	
	override public func query(sql : String) -> DataTable {
		let result : DataTable = DataTable();
		var queryHandler : OpaquePointer? = nil;
		if(self.connect()){
			do{
				if(sqlite3_prepare_v2(databaseHandler, sql , -1, &queryHandler, nil) == SQLITE_OK){
					while(sqlite3_step(queryHandler) == SQLITE_ROW){
						let row : DataRow = DataRow();
						for i in 0 ..< sqlite3_column_count(queryHandler){
                            if (sqlite3_column_text(queryHandler, i) != nil) {
                                row.addColumn(column: DataColumn(n: String.init(cString:sqlite3_column_name(queryHandler, i)), v: String.init(cString: sqlite3_column_text(queryHandler, i))));
                            }
                            else {
                                row.addColumn(column: DataColumn(n: String.init(cString:sqlite3_column_name(queryHandler, i)), v: ""));
                            }
						}
						result.addRow(row : row);
					}
				}
				else{
					if(errorTable != ""){
						//runSafeQuery(sql: String(format: "insert into %@ (%@_sql_text,%@_error_text) values ('%@','%@')", errorTable,errorTable,errorTable,sql,String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!));
					}
					#if DEBUG
						print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
					#endif
					lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
				}
			}
			sqlite3_finalize(queryHandler);
			self.disconnect();
		}
		return result;
	}
	
	override public func findRowID(sql : String,tableRow : NSInteger) -> NSInteger{
		var result : NSInteger = 0;
		let sql2 : String = sql.replacingOccurrences(of: "select", with: "select rownum,") ;
		if(connect()){
			do{
				var queryHandler : OpaquePointer? = nil;
				if(sqlite3_prepare_v2(databaseHandler, sql2 , -1, &queryHandler, nil) == SQLITE_OK){
					var i : NSInteger = 0;
					while(sqlite3_step(queryHandler) == SQLITE_ROW){
						if(i == tableRow){
							result = Int(sqlite3_column_int(queryHandler, 0));
						}
						i += 1;
					}
				}
				sqlite3_finalize(queryHandler);
				disconnect();
			}
		}
		return result;
	}
	
	override public func columns(sql : String) -> [String] {
		var result : [String] = [];
		if(self.connect()){
			do{
				var queryHandler : OpaquePointer? = nil;
				if(sqlite3_prepare_v2(databaseHandler, sql , -1, &queryHandler, nil) == SQLITE_OK){
					for i in 0 ..< sqlite3_column_count(queryHandler){
						result.append(String(cString: sqlite3_column_name(queryHandler, i)));
					}
				}
				else{
					#if DEBUG
						print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
					#endif
					lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
				}
				sqlite3_finalize(queryHandler);
				self.disconnect();
			}
		}
		return result;
	}
	
	override public func getProviderName() -> String { return "SQLite"; }
}
