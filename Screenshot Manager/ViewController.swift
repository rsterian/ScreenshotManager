//
//  ViewController.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 rileyq. All rights reserved.
//

//  Using https://github.com/eonil/FileSystemEvents
//  MIT License

//http://stackoverflow.com/questions/24696044/nsfilemanager-fileexistsatpathisdirectory-and-swift
//http://stackoverflow.com/questions/12153504/accessing-the-desktop-in-a-sandboxed-app



import Cocoa
import Foundation
import EonilFileSystemEvents

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private var	monitor	=	nil as FileSystemEventMonitor?
    
    @IBOutlet var desktop_select_button: NSButton!
    @IBOutlet var save_location_select_button: NSButton!
    //@IBOutlet var go_button: NSButton!
    //@IBOutlet var textbar: NSTextField!
    @IBOutlet var pathname_input: NSTextField!
    @IBOutlet var pathname_destination: NSTextField!
    
    var pathname_desktop:String = ""
    var pathname_save_location:String = ""
    
    @IBAction func press_desktop_button(_ sender: NSButton) {
//        if(pathname_input.stringValue != ""){
//            let path:String = pathname_input.stringValue
//            
//            textbar.stringValue = "You entered " + path
//            
//        } else {
//            textbar.stringValue = "blank"
//        }
        
        pathname_desktop = get_dir()
        if(pathname_desktop == "ERROR"){
            exit(EXIT_FAILURE)
        } else if(pathname_desktop == "bad"){
            return
        } //otherwise, pathname is valid
        
        print("received " + pathname_desktop)
        pathname_input.stringValue = pathname_desktop
    }
    
    @IBAction func press_save_button(_ sender: NSButton) {
        pathname_save_location = get_dir()
        if(pathname_save_location == "ERROR"){
            exit(EXIT_FAILURE)
        } else if(pathname_save_location == "bad"){
            return
        }
        
        pathname_destination.stringValue = pathname_save_location
    }
    
    
    @IBAction func press_gb(_ sender: NSButton) {
        print("pressed go!")
        
        pathname_desktop = pathname_input.stringValue
        make_temp(path: pathname_desktop)
    }

    
//    @IBAction func test_check_for_updates(_ sender: NSButton) {
//        pathname = pathname_input.stringValue
//        check_for_updates(path: pathname)
//    }
//    
//    @IBAction func test_print_running_app(_ sender: NSButton) {
//        //pathname = pathname_input.stringValue
//        print_running_app()
//    }
    
    @IBAction func do_eonil(_ sender: NSButton) {
        var full:String
        if(pathname_desktop.characters.last == "/"){
            full = pathname_desktop + "Screen Shot "
        } else {
            full = pathname_desktop + "/Screen Shot "
        }
        
        if(pathname_save_location.characters.last != "/"){
            pathname_save_location.append("/")
        }
        
        print("source pathname is " + pathname_desktop)
        print("destination pathname is " + pathname_save_location)
        monitor = FileSystemEventMonitor(
            pathsToWatch: [pathname_desktop],
            latency: 0,
            watchRoot: false,
            queue: DispatchQueue.main) { (events: [FileSystemEvent])->() in
                //print(events)
//                print("================")
//                print("MODIFICATION")
//                //print(events.count)
//                print(events[0].path)
//                //print(events[0].flag)
//                print(full + get_format_time() + ".png")
//                print("================")
                let time:String = get_format_time()
//                print(time)
                print(events.count)
                for i in events{
//                    print(i.path)
//                    print(i.flag)
                    if(i.flag.description == "ItemRenamed"){
                        print("flag match")
                        
                        match_handler(source: self.pathname_desktop,
                                      dest: self.pathname_save_location,
                                      file: i.path ,
                                      time: time)
                        break
                    }
                }
                
        }
        //get_format_time()
    }
    
    //TODO:
    //get frontmost application on FSEvent (line 91ish)
    //find new screenshot on desktop DONE
    //move screenshot to appropriate directory based on app
    //      create directory if it doesn't exist
    //clean up
    //      real buttons, consolidate functions
    //doublecheck that the timestamps are correct DONE?

}

