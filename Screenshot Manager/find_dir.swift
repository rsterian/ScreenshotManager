//
//  find_dir.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 rileyq. All rights reserved.
//

import Cocoa
import Foundation
import EonilFileSystemEvents

func compHandler(input: Int) -> Void{
    print(String(input) + " in the comphandler")
    return
}

func get_dir() -> String{
    let panel = NSOpenPanel()
    panel.title = "Choose a directory"
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    
    //one way to get the pathname in the format:
    //  /Users/rsterian/Desktop/
    
    var url_string:String
    
    let user_response = panel.runModal()
    if(user_response == NSFileHandlingPanelOKButton){
        url_string = (panel.url?.path)!
    } else if (user_response == NSFileHandlingPanelCancelButton){
        url_string = "bad"
    } else {
        url_string = "ERROR"
    }
    print(url_string)

    
    
    /*get the pathname in the same format
    passes 1 to compHandler if user selects Open
    passes 0 to compHandler if user selects Cancel
 
    But wait, there's a problem
    execution continues before the window closes
    so panel.url will be nil
    panel.begin(completionHandler: compHandler)
    print(panel.url)*/
    
    return url_string
}

func make_temp(path: String){
    
    print("in make_temp")
    
    let fm = FileManager()
    let full_path:String = path + "/temp/"
    if(fm.fileExists(atPath: full_path)){
        //temp already exists
        print("path already exists, but that's okay")
        return
    }
    print("trying to make a directory at ")
    print(full_path)
    
    do{
        try fm.createDirectory(atPath: full_path, withIntermediateDirectories: false, attributes: nil)
        print("Success! Directory created")
    } catch let error as NSError{
        //print("Error: Invalid pathname")
        print(error.description)
        print(error.localizedFailureReason!)
    }
    
}

//TODO
//doesn't actually check anything yet
func check_for_updates(path: String){
    print("in check_for_updates")
    if(path == ""){
        return
    }
    print(path)
    let fm = FileManager()
    do{
        try print(fm.contentsOfDirectory(atPath: path))
    } catch let error as NSError{
        print("caught")
        //print(error.description)
        print(error.localizedFailureReason!)
    }
    
}

func print_running_app(){
    let workspace = NSWorkspace()
    for element in workspace.runningApplications{
        print(element.localizedName!)
    }
    sleep(5)
    print("FRONTMOST APP IS ")
    print(workspace.frontmostApplication!.localizedName!)
}

//http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
//http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns
func get_format_time() -> String{
    let date = Date()
    let day_formatter = DateFormatter()
    day_formatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
    let result = day_formatter.string(from: date)
    //print(result)
    return result
}

func match_handler(path: String){
    print("It's a match at " + path)
    let workspace = NSWorkspace()
    let frontmost:String = workspace.frontmostApplication!.localizedName!
    
    
}
