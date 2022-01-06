//
//  Registry.swift
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class RegistryPropertyStore : PropertyStore {
    
	override public init(src : String = (Bundle.main.path(forResource: "Info", ofType: "plist"))!) {
		super.init(src : src);
		self.prepare();
    }
    
    private func prepare(){
        if(!FileManager.default.fileExists(atPath: source)){
            NSDictionary.init().write(toFile: source, atomically: false);
        }
    }
	
    public func purge(){
        let dict : NSMutableDictionary = NSMutableDictionary(dictionary: NSDictionary.init(contentsOfFile: self.source)!);
        for pair in dict{
            if((pair.value as? String) != nil){
                dict.removeObject(forKey: pair.key as! String);
            }
        }
        dict.write(toFile: self.source, atomically: false);
    }

    
    /// This method returns all keys
    public func getAll() -> NSDictionary{
        let dict : NSDictionary = NSDictionary.init(contentsOfFile: self.source)!;
        return dict;
    }
    
   override public func getProperty(key : String) -> Any {
        var mfinal : String = "";
    let dict : NSDictionary = NSDictionary.init(contentsOfFile: self.source) ?? NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "Info.plist", ofType: "")!)!;
        for cursorKey in dict.allKeys{
            if(cursorKey as! String == key){
                mfinal = dict.value(forKey: (cursorKey as! String)) as! String;
				return mfinal;
            }
        }
        return mfinal;
    }
    
    override public func getKeys() -> [String] {
        let dict : NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: self.source)!;
        #if os(macOS)
            return dict.attributeKeys;
        #else
            return dict.allKeys as! [String];
        #endif
    }
    
    override public func setProperty(key : String, value : Any) {
        do{
            let dict : NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: self.source)!;
            dict.setValue(value , forKey: key);
            dict.write(toFile: self.source, atomically: true);
        }
    }
	
	public func getRegistry() -> String { return self.getSource(); }
}
