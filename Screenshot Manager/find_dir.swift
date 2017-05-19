//
//  find_dir.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 Riley Sterian. All rights reserved.
//

import Cocoa
import Foundation
import EonilFileSystemEvents

//https://gist.github.com/ericdke/fec20e6db9e0aa25e8ea
func show_notification(ss_name:String, dest:String) -> Void {
    let notification = NSUserNotification()
    notification.title = ss_name + " moved"
    notification.informativeText = "Moved to " + dest
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.default.deliver(notification)
}

func get_dir() -> String{
    let panel = NSOpenPanel()
    panel.title = "Choose a directory"
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    panel.canCreateDirectories = true

    var url_string:String
    
    let user_response = panel.runModal()
    if(user_response == NSFileHandlingPanelOKButton){
        url_string = (panel.url?.path)!
    } else if (user_response == NSFileHandlingPanelCancelButton){
        url_string = "bad"
    } else {
        url_string = "ERROR"
    }
    
    return url_string
}

//http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
//http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns
func get_format_time() -> String{
    let date = Date()
    let day_formatter = DateFormatter()
    day_formatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
    let result = day_formatter.string(from: date)
    return result
}

//https://code.tutsplus.com/tutorials/swift-and-regular-expressions-swift--cms-26626
func path_is_screenshot(path: String) -> Bool{
    let path_components = path.components(separatedBy: "/")
    let ss_name = path_components[path_components.count - 1]
    
    // (1): 
    let pat = "\\bScreen Shot \\d{4}\\-\\d{2}\\-\\d{2}\\ at\\ \\d{1,2}\\.\\d{2}\\.\\d{2}\\ (A|P)M\\ ?\\d*\\.png\\b"
    // (2):
    let testStr = ss_name
    // (3):
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    // (4):
    let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.characters.count))
    
    return (matches.count == 1)
}

func get_time_from_path(path: String) -> String{
    assert(path_is_screenshot(path: path))
    let path_components = path.components(separatedBy: "/")
    let ss_name = path_components[path_components.count - 1]

    var time = ss_name
    time.removeSubrange(time.startIndex..<time.index(time.startIndex, offsetBy: 12)) //remove up to time
    
    time.removeSubrange(time.index(time.endIndex, offsetBy: -4)..<time.endIndex) //remove .png
    return time
}

func match_handler(source: String, dest: String, file: String, time:String, notify:Bool, frontmost:String){
    let fm = FileManager()
    let new_path:String = dest + frontmost

    if(!fm.fileExists(atPath: new_path)){
        do{
            try fm.createDirectory(atPath: new_path, withIntermediateDirectories: false, attributes: nil)
        }catch{
            //print("ERROR")
        }
    }
    
    if(fm.fileExists(atPath: new_path + "/Screenshot " + time + ".png")){
        return
    }
    
    do{
        try fm.moveItem(atPath: file, toPath: new_path + "/Screenshot " + time + ".png")
        if(notify){
            show_notification(ss_name: file, dest: new_path)
        }
        return 
    } catch _ as NSError{
        //print(error.localizedFailureReason!)
        //print(error.localizedDescription)
    }
    return
}
