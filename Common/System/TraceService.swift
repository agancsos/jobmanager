//
//  TracerService.swift
//
//  Created by Abel Gancsos on 3/9/19.
//  Copyright © 2019 Abel Gancsos. All rights reserved.
//

import Foundation

public enum TraceCategory : Int, CaseIterable{
	case NONE
	case MISC
	case SYSTEM
	case DATABASE
	case SECURITY
	case APPLICATION
	case REST
	
	public func getName() -> String {
		switch(self) {
			case .NONE:
				return "None";
			case .MISC:
				return "MISC";
			case .SYSTEM:
				return "System";
			case .SECURITY:
				return "Security";
			case .DATABASE:
				return "Database";
			case .APPLICATION:
				return "Application";
			case .REST:
				return "Rest";
		}
	}
	
	public func getRawValue() -> Int {
		switch(self) {
			case .NONE:
				return 0;
			case .MISC:
				return 1;
			case .SYSTEM:
				return 2;
			case .SECURITY:
				return 3;
			case .DATABASE:
				return 4;
			case .APPLICATION:
				return 5;
			case .REST:
				return 6;
		}
	}
}

public enum TraceLevel : Int, CaseIterable {
	case NONE
	case ERROR
	case WARNING
	case INFORMATIONAL
	case VERBOSE
	case DEBUG
	
	public func getName() -> String {
		switch(self) {
			case .NONE:
				return "None";
			case .ERROR:
				return "ERROR";
			case .WARNING:
				return "WARN";
			case .INFORMATIONAL:
				return "INFO";
			case .VERBOSE:
				return "VERB";
			case .DEBUG:
				return "DEBUG";
		}
	}
	
	public func getRawValue() -> Int {
		switch(self) {
			case .NONE:
				return 0;
			case .ERROR:
				return 1;
			case .WARNING:
				return 2;
			case .INFORMATIONAL:
				return 3;
			case .VERBOSE:
				return 4;
			case .DEBUG:
				return 5;
		}
	}
}

public class TraceService {
	private var logFilePath : String  = "";
	private var level       : TraceLevel = .ERROR;
	
	public init(path : String = "", level : TraceLevel = .ERROR) {
		logFilePath = path;
		self.level = level;
	}
	
	private func trace(message : String = "", display : Bool = false) {
		let format : DateFormatter = DateFormatter();

		if(display) {
			print("\(message)\n");
		}
		do {
			try (String(format : "%@ | %@", format.string(from: Date()), message) as NSString).write(
				toFile: logFilePath,
				atomically: true,
				encoding: String.Encoding.utf8.rawValue);
		}
		catch { }
	}
	
	public func traceError(message : String) {
		if(level.rawValue > 0){
			trace(message : "ERROR | \(message)", display : false);
		}
	}
	public func traceWarning(message : String) {
		if(level.rawValue > 1){
			trace(message : "WARN | \(message)", display : false);
		}
	}
	public func traceInformational(message : String) {
		if(level.rawValue > 2){
			trace(message : "INFO | \(message)", display : false);
		}
	}
	public func traceVerbose(message : String) {
		if(level.rawValue > 3){
			trace(message : "VERB | \(message)", display : true);
		}
	}
	public func traceDebug(message : String) {
		trace(message : "DEBUG | \(message)", display : true);
	}
	
	public func setLogFilePath(path : String = "") { logFilePath = path; }
	public func setTraceLevel(level : TraceLevel = .ERROR) { self.level = level; }
	public func getLogFilePath() -> String { return logFilePath; }
	public func getTraceLevel() -> TraceLevel { return level; }
}
