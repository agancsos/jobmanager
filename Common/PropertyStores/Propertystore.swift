//
//  Propertystore.swift
//
//  Created by Abel Gancsos on 2/27/19.
//  Copyright © 2019 Abel Gancsos. All rights reserved.
//

import Foundation

public class PropertyStore {
	internal var source : String = "";
	
	public init(src : String = "") {
		source = src;
	}
	
	internal func readFile() -> String {
		var result : String = "";
		do {
			try result = (NSString(contentsOfFile: source, encoding: String.Encoding.utf8.rawValue) as String);
		}
		catch {
			
		}
		return result;
	}
	
	internal func writeData(data : String) {
		do {
			try data.write(to: URL.init(string: source)!, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
		}
		catch {
			
		}
	}
	
	public func getProperty(key : String) -> Any { return ""; }
	public func setProperty(key : String, value : Any) { }
	public func getKeys() -> [String] { return []; }
	public func getSource() -> String { return source; }
	public func setSource(src : String) { source = src; }
}
