//
//  AppDelegate.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 Riley Sterian. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var	monitor	=	nil as FileSystemEventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        // Insert code here to initialize your application
//        var	monitor = FileSystemEventMonitor(
//            pathsToWatch: [NSString(string: "~/Documents").expandingTildeInPath],
//            latency: 1,
//            watchRoot: true,
//            queue: DispatchQueue.main) { (events: [FileSystemEvent])->() in
//                print(events)
//                print("hello")
//        }
//        print("INITIALIZATION SUCCESS")
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        monitor = nil
    }
    
}

