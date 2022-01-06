//
//  Version.swift
//
//  Created by Abel Gancsos on 9/23/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class Version {
    var majorVersion     : Int = 0;
    var minorVersion     : Int = 0;
    var buildVersion     : Int = 0;
    var buildDescription : String = "";
    
    init() {
        
    }
    
    convenience init(major : Int) {
        self.init();
        self.majorVersion = major;
    }
    
    convenience init(major : Int, minor : Int) {
        self.init(major : major);
        self.minorVersion = minor;
    }
    
    convenience init(major : Int, minor : Int, build : Int) {
        self.init(major : major, minor : minor);
        self.buildVersion = build;
    }
    
    convenience init(major : Int, minor : Int, build : Int, description : String) {
        self.init(major : major, minor : minor, build : build);
        self.buildDescription = description;
    }
    
    public func version() -> String {
        return String(format: "%d.%d.%d", self.majorVersion, self.minorVersion, self.buildVersion);
    }
}
