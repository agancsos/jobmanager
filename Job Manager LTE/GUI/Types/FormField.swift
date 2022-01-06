import Foundation
import UIKit

public enum FormFieldType : NSInteger {
    case TEXTFIELD = 100;
    case PASSWORD = 101;
    case POPUP = 102;
    case TEXTAREA = 103;
    case SWITCH = 104;
    case DEFAULT = 105;
}

public class FormField {
    var type       : FormFieldType = FormFieldType.DEFAULT;
    var label      : String = "";
    var value      : [Any] = [];
    var options    : [Any] = [];
    var editable   : Bool = false;
    
    public init(t : FormFieldType, l : String, v : [Any], o : [Any], e : Bool){
        self.type = t;
        self.label = l;
        self.value = v;
        self.options = o;
        self.editable = e;
    }
}
