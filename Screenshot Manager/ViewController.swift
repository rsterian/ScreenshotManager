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
    private var frontmost_monitor = nil as FileSystemEventMonitor?
    var frontmost_app = ""
    var app_queue:[String] = []
    
    @IBOutlet var desktop_select_button: NSButton!
    @IBOutlet var save_location_select_button: NSButton!
    //@IBOutlet var go_button: NSButton!
    //@IBOutlet var textbar: NSTextField!
    @IBOutlet var pathname_input: NSTextField!
    @IBOutlet var pathname_destination: NSTextField!
    @IBOutlet var notification_check: NSButton!
    
    var pathname_desktop:String = ""
    var pathname_save_location:String = ""
    
    @IBAction func press_desktop_button(_ sender: NSButton) {
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
    
    
    //TODO
    //comment out or remove this function! 
    //it's not needed!!!
//    @IBAction func press_gb(_ sender: NSButton) {
//        print("pressed go!")
//        
//        pathname_desktop = pathname_input.stringValue
//        make_temp(path: pathname_desktop)
//    }
    
    @IBAction func do_eonil(_ sender: NSButton) {
        
        if(pathname_save_location.characters.last != "/"){
            pathname_save_location.append("/")
        }
        
        let workspace = NSWorkspace()
        
        
        print("source pathname is " + pathname_desktop)
        print("destination pathname is " + pathname_save_location)
        frontmost_monitor = FileSystemEventMonitor(
            pathsToWatch: [pathname_desktop],
            latency: 0,
            watchRoot: false,
            queue: DispatchQueue.main) { (fm_events: [FileSystemEvent])->() in
                for i in fm_events{
                    if(i.flag.description == "ItemRenamed, ItemXattrMod" && path_is_screenshot(path: i.path)){
                        self.app_queue.append(workspace.frontmostApplication!.localizedName!)
                    }
                }
                print("fast")
                print(self.app_queue)

        }
        
        
        monitor = FileSystemEventMonitor(
            pathsToWatch: [pathname_desktop],
            latency: 1,
            watchRoot: false,
            queue: DispatchQueue.main) { (events: [FileSystemEvent])->() in

                print(events.count)
                for i in events{
                    print(i.path)
                    print(i.flag)
                    //print(i.flag.description == "ItemRenamed, ItemXattrMod")

                    if(i.flag.description == "ItemRenamed, ItemXattrMod" && path_is_screenshot(path: i.path)){
                        print("flag match")
                        
                        match_handler(source: self.pathname_desktop,
                                      dest: self.pathname_save_location,
                                      file: i.path ,
                                      time: get_time_from_path(path: i.path),
                                      notify: self.notification_check.state == 1,
                                      //frontmost: workspace.frontmostApplication!.localizedName!)
                                      //frontmost: self.frontmost_app)
                                      frontmost: self.app_queue.remove(at: 0))

                        print("slow")
                        print(self.app_queue)

                    }
                }
        }
        //get_format_time()
        //NSApp.miniaturizeAll(self)
        //TODO uncomment above
    }

}

