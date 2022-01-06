import Foundation
import IncryptEncode
import Common
import Data

public class DbTraceService {
    private static var dataService : DataService = DataService.getInstance();
    private static var traceLevel  : TraceLevel = TraceLevel(rawValue: Int(Helper.store.getProperty(key: "TraceLevel") as! String) ?? 2)!

	private static func trace(message : String, category: TraceCategory, level: TraceLevel) {
		_ = self.dataService.runServiceQuery(query: "insert into message (message_text, message_level, message_category) values ('\(message)', '\(level.getRawValue())', '\(category.getRawValue())')");
	}
	
	public static func traceError(message : String, category: TraceCategory) {
		if (traceLevel.getRawValue() > 0) {
			trace(message: message, category: category, level: TraceLevel.WARNING);
		}
	}

	public static func traceWarning(message : String, category: TraceCategory) {
		if (traceLevel.getRawValue() > 1) {
			trace(message: message, category: category, level: TraceLevel.ERROR);
		}
	}

	public static func traceInformational(message : String, category: TraceCategory) {
		if (traceLevel.getRawValue() > 2) {
			trace(message: message, category: category, level: TraceLevel.INFORMATIONAL);
		}
	}

	public static func traceVerbose(message : String, category: TraceCategory) {
		if (traceLevel.getRawValue() > 3) {
			trace(message: message, category: category, level: TraceLevel.VERBOSE);
		}
	}

	public static func traceDebug(message : String, category: TraceCategory) {
		trace(message: message, category: category, level: TraceLevel.DEBUG);
	}

	/// Adds a message in the database
	/// - Parameter message: Message
	/// - Parameter level: Trace level
	/// - Parameter category: Trace category
	public static func auditMessage(message : String, level : TraceLevel, category: TraceCategory) {
		if (traceLevel.getRawValue() > level.getRawValue() - 1) {
			trace(message: message, category: category, level: level);
		}
	}
    
    public static func getMessage() -> DataTable {
        return dataService.serviceQuery(query: "select message_id, message_category, message_text, message_level, last_updated_date from message order by message_id desc");
    }
    
    public static func getMessage() -> [Message] {
        var result : [Message] = [];
        let messages = dataService.serviceQuery(query: "select message_id, message_category, message_text, message_level, last_updated_date from message order by message_id desc");
        for row : DataRow in messages.getRows() {
            let message = Message(id: Int(row.getColumn(name: "MESSAGE_ID")?.getValue() ?? "0") ?? 0);
            message.setText(a: row.getColumn(name: "MESSAGE_TEXT")?.getValue() ?? "");
            message.setLevel(a: TraceLevel.init(rawValue: Int(row.getColumn(name: "MESSAGE_LEVEL")?.getValue() ?? "0") ?? 0) ?? TraceLevel.NONE);
            message.setCategory(a: TraceCategory.init(rawValue: Int(row.getColumn(name: "MESSAGE_CATEGORY")?.getValue() ?? "0") ?? 0) ?? TraceCategory.NONE);
            message.setLastUpdatedDate(a: row.getColumn(name: "LAST_UPDATED_DATE")?.getValue() ?? "");
            result.append(message);
        }
        return result;
    }
    
    public static func purge() {
        _ = dataService.runServiceQuery(query: "DELETE FROM message");
    }

	public static func setTraceLevel(level: TraceLevel) { traceLevel = level; }
	public static func getTraceLevel() -> TraceLevel { return traceLevel; }
}
