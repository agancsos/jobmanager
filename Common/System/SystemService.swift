//
//  System.swift
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class SystemService {
	private var source : String = "";
	private var target : String = "";
	
	
	/// This is the full constructor
	///
	/// - Parameters:
	///   - s: Full path of the source object
	///   - t: Full path of the target object
	init(s : String = "", t: String = "") {
		self.source = s;
		self.target = t;
	}
	
	
	/// This method checks if the file exists at a given path
	///
	/// - Parameter path: Full path of the file
	/// - Returns: True if it exists, false if not
	public static func fileExists(path : String) -> Bool {
		return FileManager.default.fileExists(atPath: path);
	}
	
	
	/// This method checks if a directory exists
	///
	/// - Parameter path: Full path of the directory
	/// - Returns: True if it exists, false if not
	public static func directoryExists(path : String) -> Bool {
		var isdir : ObjCBool = false;
		if(FileManager.default.fileExists(atPath: path, isDirectory: &isdir)) {
			if(isdir.boolValue) {
				return true;
			}
		}
		return false;
	}
	
	
	/// This method retrieves the contents of a file
	///
	/// - Parameter path: Path of the file
	/// - Returns: Data from file
	public static func readFile(path : String = "") -> String {
		var result : String = "";
		do {
			try result = (NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String);
		}
		catch { }
		return result;
	}
	
	
	/// This method writes data to a file
	///
	/// - Parameters:
	///   - path: Full path of the target object
	///   - data: Text to write
	/// - Returns: Successful if no errors, false if there was
	public static func writeFile(string path : String, data : String) -> Bool {
		do {
			try data.write(to: URL.init(string: path)!, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
		}
		catch {
			return false;
		}
		return true;
	}
	
	
	/// This method retrieves the version of the application
	///
	/// - Returns: Version
	public static func getVersion() -> Version {
		var version : Version = Version();
		let comps : [String.SubSequence] = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).split(separator: ".");
		version = Version(major: (Int(comps[0]) != nil ? Int(comps[0])! : 0),
						  minor: (Int(comps[1]) != nil ? Int(comps[1])! : 0),
						  build: (Int(comps[2]) != nil ? Int(comps[2])! : 0));
		return version;
	}
	
	public static func urlEncode(text : String) -> String{
		var mfinal : String = "";
		mfinal = text;
		mfinal = mfinal.replacingOccurrences(of: " ", with: "%20");
		mfinal = mfinal.replacingOccurrences(of: "\n", with: "%2A");
		return mfinal;
	}
	
	// Checks if there is an internet connection
	///
	/// - Returns: True if yes, False if no
	public static func internet() -> Bool{
		do{
			let rawContent : String = try (String(contentsOf: URL.init(string: "https://www.google.com")!,
												  encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
			if(rawContent == ""){
				return false;
			}
			else{
				return true;
			}
		}
		catch { }
		return false;
	}
	
	// Check if site is available
	///
	/// - Parameter domain: URL to site
	/// - Returns: True if accessible, False if not
	public static func server(domain : String) -> Bool{
		if(internet()){
			do{
				let rawContent : String = try (String(contentsOf: URL.init(string: domain)!,
													  encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
				if(rawContent == ""){
					return false;
				}
				else{
					return true;
				}
			}
			catch { }
		}
		return false;
	}
	
	public static func getYear() -> String{
		let date : Date = Date();
		let formatter : DateFormatter = DateFormatter();
		formatter.dateFormat = "YYYY";
		return formatter.string(from : date);
	}
    
    #if os(macOS)
    public static func runCMD(a : [String]) -> String {
        let task = Process();
        let outputPipe = Pipe();
        task.launchPath = "/usr/bin/env";
        task.arguments = a;
        task.launch();
        task.standardOutput = outputPipe;
        task.waitUntilExit();
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile();
        return String(decoding: outputData, as: UTF8.self)
    }
    #endif
    
    public static func contentsOfURL(url : URL, _ completion: @escaping (String) -> ()) {
        do {
            let rawContent = try String(contentsOf: url, encoding: .utf8);
            completion(rawContent);
        }
        catch let error {
            completion(error.localizedDescription);
        }
    }
}
