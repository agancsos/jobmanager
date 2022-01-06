//
//  AppDelegate.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Cocoa
import Common
import JobManager

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Helper.initializeDirectories();
        Helper.currentProfile = ProfileService.getProfile(id: 0);
        if (!LicenseService.isLicensed()) {
            let license = GUIService.input(prompt: "License", defaultValue: "", frame: NSRect(x: 50, y: 50, width: 300 , height: 30));
            if (!LicenseService.isValid(a: license)) {
                NSRunningApplication.current.terminate();
            }
            else {
                _ = LicenseService.register(a: license);
            }
        }
        
        CustomActionService.mainMenu = window.menu ?? NSMenu.init();
        CustomActionService.setCustomMenuOptions();
        window.contentView = MainController(frame: window.frame);
        if (SR.safeMode != "1") {
            //HostService.launch(a: Helper.currentProfile);
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        if (SR.killOnExit == "1") {
            //_ = SystemService.runCMD(a: ["killall \(SR.hostProcessName)"]);
            //HostService.removeHostPID(a: Helper.currentProfile);
        }
    }
}

