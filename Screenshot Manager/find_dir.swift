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

//https://code.tutsplus.com/tutorials/swift-and-regular-expressions-swift--cms-26626
func path_is_screenshot(path: String) -> Bool{
    let path_components = path.components(separatedBy: "/")
    print(path_components)
    let ss_name = path_components[path_components.count - 1]
    
    let pat = "\\bScreen Shot \\d{4}\\-\\d{2}\\-\\d{2}\\ at\\ \\d{1,2}\\.\\d{2}\\.\\d{2}\\ (A|P)M\\.png\\b"
    // (2):
    let testStr = ss_name
    // (3):
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    // (4):
    let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.characters.count))
    
    return (matches.count == 1)
}

func get_time_from_path(path: String){
    let path_components = path.components(separatedBy: "/")
    print(path_components)
    let ss_name = path_components[path_components.count - 1]

    print("in get_time_from_path")
    var time = ss_name
    time.removeSubrange(time.startIndex..<time.index(time.startIndex, offsetBy: 12)) //remove up to time
    time.removeSubrange(time.index(time.endIndex, offsetBy: -4)..<time.endIndex) //remove .png
    print(time)
}

func match_handler(source: String, dest: String, file: String, time:String){
    print("Going to move " + file + " from " + source + " to " + dest)
    
    ////////
    get_time_from_path(path: file)
    ////////
    
    let workspace = NSWorkspace()
    let frontmost:String = workspace.frontmostApplication!.localizedName!
    
    let fm = FileManager()
    let new_path:String = dest + frontmost
    
    if(!fm.fileExists(atPath: new_path)){
        do{
            try fm.createDirectory(atPath: new_path, withIntermediateDirectories: false, attributes: nil)
        }catch{
            print("ERROR")
        }
    }
    
    if(fm.fileExists(atPath: new_path + "/Screen Shot " + time + ".png")){
        print("didn't actually move this time")
        return
    }
    
    do{
        try fm.moveItem(atPath: file, toPath: new_path + "/Screen Shot " + time + ".png")
    } catch let error as NSError{
        print(error.localizedFailureReason!)
//        print(file)
//        print(new_path + "/Screen Shot " + get_format_time())
        print(error.localizedDescription)
    }
}
