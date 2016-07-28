//
//  toggleLaunchAtStartup.swift
//  Recents
//
//  Created by Phil LaPier on 5/21/15.
//  Copyright (c) 2015 Philip LaPier. All rights reserved.
//
// With help from: https://github.com/RamonGilabert/Prodam/blob/master/Prodam/Prodam/LaunchStarter.swift

import Foundation

func applicationIsInStartUpItems() -> Bool {
    return (itemReferencesInLoginItems().existingReference != nil)
}

func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
    if let appURL : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef? {
            
            let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
            let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as! LSSharedFileListItemRef
            
            for (index, _) in loginItems.enumerate() {
                let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(index) as! LSSharedFileListItemRef
                if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                    if (itemURL.takeRetainedValue() as NSURL).isEqual(appURL) {
                        return (currentItemRef, lastItemRef)
                    }
                }
            }
            
            return (nil, lastItemRef)
        }
    }
    
    return (nil, nil)
}

func toggleLaunchAtStartup() {
    let itemReferences = itemReferencesInLoginItems()
    let shouldBeToggled = (itemReferences.existingReference == nil)
    if let loginItemsRef = LSSharedFileListCreate( nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef? {
        if shouldBeToggled {
            if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
                print("Add login item")
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
            }
        } else {
            if let itemRef = itemReferences.existingReference {
                print("Remove login item")
                LSSharedFileListItemRemove(loginItemsRef,itemRef);
            }
        }
    }
}