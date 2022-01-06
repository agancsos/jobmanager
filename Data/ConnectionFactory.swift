//
//  ConnectionFactory.swift
//
//  Created by Abel Gancsos on 3/1/19.
//  Copyright © 2019 Abel Gancsos. All rights reserved.
//

import Foundation
public class ConnectionFactory {
	private static var providers : [DataConnection] = [
		DataConnectionSQLite()
	];
	
	public static func createConnection(name : String) -> DataConnection? {
		if(name.lowercased() == "sqlite") {
			return DataConnectionSQLite();
		}
		return nil;
	}
	
	public static func getProviders() -> [DataConnection] { return ConnectionFactory.providers; }
}
