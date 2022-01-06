//
//  LicenseService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/14/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class LicenseService {
    private static var bundleRegistry  : RegistryPropertyStore = RegistryPropertyStore(src: "\(Bundle.main.bundlePath)/Info.plist");
    private static var applicationMode : ApplicationMode = ApplicationMode.init(rawValue: Int(bundleRegistry.getProperty(key: "ProductType") as? String ?? "0") ?? 0) ?? .CONSUMER;
    public static var enabled          : Bool = (applicationMode == .CONSUMER ? false : true);
    private static var personalLicense : String = "";
    
    public static func isValid (a: String = "") -> Bool {
        if (a != "") {
            if (SecurityService.getEncoded(a: a) == personalLicense) {
                return true;
            }
            
        }
        return false;
    }
    
    public static func register (a: String) -> Bool {
        // Encode provided license
        Helper.store.setProperty(key: "License", value: SecurityService.getEncoded(a: a));
        return false;
    }
    
    public static func isLicensed() -> Bool {
        if (!enabled) {
            return true;
        }

        if (LicenseService.isValid(a: SecurityService.getDecoded(a: (Helper.store.getProperty(key: "License") as? String) ?? ""))) {
            return true;
        }
        return false;
    }
    
    public static func getApplicationMode() -> ApplicationMode {
        return applicationMode;
    }
}
