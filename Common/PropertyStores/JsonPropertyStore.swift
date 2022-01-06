//
//  JsonPropertyStore.swift
//
//  Created by Abel Gancsos on 2/28/19.
//  Copyright © 2019 Abel Gancsos. All rights reserved.
//

import Foundation

public class JsonPropertyStore : PropertyStore {
	private var handler : Any? = nil;
	
	override public init(src : String = "") {
		super.init(src : src);
		if(FileManager.default.fileExists(atPath: source)) {
			var rawContent : String = "";
			do {
				try rawContent = String(contentsOfFile: source);
			}
			catch { }
			do {
				try handler = JSONSerialization.jsonObject(with: rawContent.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves);

			}
			catch {
				
			}
		}
	}
	
	override public func getProperty(key : String) -> Any {
		if(handler != nil) {
			if((handler as? NSObject) != nil) {
				return ((handler as! NSObject).value(forKey: key) as? String) ?? "";
			}
		}
		return "";
	}
	
	override public func setProperty(key : String, value : Any) {
		if(handler != nil) {
			if((handler as? NSObject) != nil) {
				(handler as! NSObject).setValue(value, forKey: key);
			}
			let data = try? JSONSerialization.data(withJSONObject: handler!, options: JSONSerialization.WritingOptions.prettyPrinted);
			if(data != nil) {
				let json = String(data: data!, encoding: String.Encoding.utf8);
				writeData(data: json!);
			}
		}
	}
	
	override public func getKeys() -> [String] {
		if(handler != nil) {
			
		}
		return [];
	}
}
