//
//  SR.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation

public class SR {
    public static var basePath  : String = "\(NSHomeDirectory())/Library/Application Support/Job Monitor";
    public static var settingsFilePath   : String = "\(basePath)/config.plist";
    public static var copyrightOwner     : String = "Gancsos Labs";
    public static var hostProcessName    : String = "jobmonitorhost"
    public static var alertFontSize      : Double = 13.0;
    public static var applicationName    : String = "Job Manager";
    public static var successFeedback    : String = "Success";
    public static var failureFeedback    : String = "Failed";
    public static var illegalProfileOp   : String = "Only one profile is currently allowed";
    public static var googleBaseURL      : String = "https://www.google.com";
    public static var googleNotSupported : String = "Google URL's not supported";
    public static var emptyNotSupported  : String = "Empty URL's not supported";
    
    public static var safeMode           : String = Helper.store.getProperty(key: "safeMode") as? String ?? "";
    public static var killOnExit         : String = Helper.store.getProperty(key: "KillHostOnExit") as? String ?? "";
    public static var autoRefreshRate    : String = Helper.store.getProperty(key: "ResultsRefreshRate") as? String ?? "30";
    
    public static var keyTraceLevel      : String = "TraceLevel";
    public static var keyEnableEditWindow: String = "EnableEditWindows";
    public static var keyBannedCompanies : String = "BannedCompanies";
    public static var keyCheckWebIcon    : String = "CheckWebIcon";
    public static var keyPurgeAudits     : String = "Purge Audits";
    public static var keyEndpoint        : String = "Endpoint";
    
    public static var copyrightLabelText             = "Gancsos Labs";
    public static var resourceSearchbarPlaceholder   = "Search...";
    public static var resourceDefaultTitleFont       = "Arial";
    public static var aboutFontName                  = "Times New Roman";
    public static var aboutFontSize                  = Float(10.0);
    public static var aboutFileName                  = "About";
    public static var resourceLogLabelSize           = Float(10.0);
    public static var resourceLogLabelFont           = "Arial";
    public static var resourceNavigationAlpha        = Float(0.5);
    public static var resourceTitleFontSize          = Float(20.0);
    public static var resourceToolbarMenu            = "menu";
    public static var keyTitleFont                   = "Arial";
    public static var keyGUITheme                    = "";
}
