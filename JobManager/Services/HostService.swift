//
//  HostService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/12/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class HostService {
    private static var dataService : DataService = DataService.getInstance();
    
    public static func launch(a: Profile) {
        let path = SystemService.runCMD(a: ["command -v \(SR.hostProcessName)"]);
        if (path == "") {
            return;
        }
        let backgroundQueue = DispatchQueue(label: "com.gancoslabs.jobmonitor.launch", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil);
        backgroundQueue.async { _ = SystemService.runCMD(a: ["\(path) --launch --profile \(a.profileId)"]); };
    }
    
    public static func hasProcess(a: Profile) -> Bool {
        return dataService.serviceQuery(query: "SELECT 1 FROM PROCESS WHERE PROFILE_ID = '\(a.profileId)'").getRows().count > 0;
    }
    
    public static func hostPID(a: Profile) -> String {
        if (hasProcess(a: a)) {
            return dataService.serviceQuery(query: "SELECT SYSTEM_ID FROM PROCESS WHERE PROFILE_ID = '\(a.profileId)'").getRows()[0].getColumn(name: "FLAG_VALUE")?.getValue() ?? "";
        }
        return "";
    }
    
    public static func removeHostPID(a: Profile) {
        _ = dataService.runServiceQuery(query: "DELETE FROM PROCESS WHERE PROFILE_ID = '\(a.profileId)'");
    }
    
    public static func addHostPID(a : Profile, b: String) {
        if (hasProcess(a: a)) {
            removeHostPID(a: a);
        }
        
        _ = dataService.runServiceQuery(query: "INSERT INTO PROCESS (PROFILE_ID, SYSTEM_ID) VALUES ('\(a.profileId)', '\(b)')");
    }
    
    public static func isStillRunning(pid : String) -> Bool {
        if (SystemService.runCMD(a: ["ps -x | grep ^\(pid)"]) != "") {
            return true;
        }
        return false;
    }
}
