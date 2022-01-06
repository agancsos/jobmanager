//
//  String.swift
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class AMGString {
    private var str : String = "";
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter value: String value to manipulate
    init(value : String ) {
        self.str = value;
    }
    
    
    /// This method pads a string
    ///
    /// - Parameters:
    ///   - len: Length of the final string
    ///   - pad: Padding to use for the final string
    /// - Returns: Padded string
    public func padRight(len : NSInteger, pad : String) -> String {
        if(self.str.count >= len) {
            return String(self.str.suffix(len));
        }
        else {
            var result : String = "";
            for _ in 0..<len {
                result += pad;
            }
            return (self.str + result);
        }
    }
    
    
    /// This method pads a string
    ///
    /// - Parameters:
    ///   - len: Length of the final string
    ///   - pad: Padding to use for the final string
    /// - Returns: Padded string
    public func padLeft(len : NSInteger, pad : String) -> String {
        if(self.str.count >= len) {
            return String(self.str.prefix(len));
        }
        else {
            var result : String = "";
            for _ in 0..<len {
                result += pad;
            }
            return (result + self.str);
        }
    }
    
    
    /// This method reverses a string
    ///
    /// - Returns: Reversed string
    public func reverse() -> String {
        return String(self.str.reversed());
    }
}
