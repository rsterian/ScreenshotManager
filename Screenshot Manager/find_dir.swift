//
//  find_dir.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 rileyq. All rights reserved.
//

import Cocoa
import Foundation

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
    do{
        let full_path:String = path + "/temp/"
        if(fm.fileExists(atPath: full_path)){
            //temp already exists
            print("path already exists, but that's okay")
            return
        }
        print("trying to make a directory at ")
        print(full_path)
        try fm.createDirectory(atPath: full_path, withIntermediateDirectories: false, attributes: nil)
    } catch let error as NSError{
        //print("Error: Invalid pathname")
        print(error.description)
    }
}



