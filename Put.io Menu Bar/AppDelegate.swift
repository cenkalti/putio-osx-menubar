//
//  AppDelegate.swift
//  Put.io Menu Bar
//
//  Created by Cenk Altı on 16/06/15.
//  Copyright (c) 2015 Cenk Altı. All rights reserved.
//

import Cocoa

let baseURL = "https://put.io/magnet?url="

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // NSVariableStatusItemLength
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Run automatically at startup
        let isStartupSet = NSUserDefaults.standardUserDefaults().boolForKey("isStartupSet")
        if !isStartupSet {
            if !applicationIsInStartUpItems() {
                toggleLaunchAtStartup()
            }
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isStartupSet")
        }
        
        // Set status icon
        let icon = NSImage(named: "StatusIcon")!
        icon.template = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.button!.window!.registerForDraggedTypes([NSStringPboardType])
        statusItem.button!.window!.delegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func clickedQuit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.Copy
    }
    
    func performDragOperation(sender: NSDraggingInfo) {
        let pasteboard = sender.draggingPasteboard()
        if let s = pasteboard.stringForType(NSStringPboardType) {
            print("s = \(s)")
            if let q = s.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                print("q = \(q)")
                if let u = NSURL(string: baseURL + q) {
                    print("u = \(u)")
                    NSWorkspace.sharedWorkspace().openURL(u)
                } else {
                    print("no u")
                }
            } else {
                print("no q")
            }
        } else {
            print("no s")
        }
    }

}

