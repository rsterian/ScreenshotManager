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
    
    @IBOutlet var select_button: NSButton!
    @IBOutlet weak var go_button: NSButton!
    @IBOutlet var textbar: NSTextField!
    @IBOutlet var pathname_input: NSTextField!
    
    var pathname:String = ""
    
    @IBAction func press_sb(_ sender: NSButton) {
        if(pathname_input.stringValue != ""){
            let path:String = pathname_input.stringValue
            
            textbar.stringValue = "You entered " + path
            
        } else {
            textbar.stringValue = "blank"
        }
        
        pathname = get_dir()
        if(pathname == "ERROR"){
            exit(EXIT_FAILURE)
        } else if(pathname == "bad"){
            return
        } //otherwise, pathname is valid
        
        print("received " + pathname)
        pathname_input.stringValue = pathname
    }
    
    @IBAction func press_gb(_ sender: NSButton) {
        print("pressed go!")
        
        pathname = pathname_input.stringValue
        
        make_temp(path: pathname)
    }

    
    @IBAction func test_check_for_updates(_ sender: NSButton) {
        pathname = pathname_input.stringValue
        check_for_updates(path: pathname)
    }
    
    @IBAction func test_print_running_app(_ sender: NSButton) {
        //pathname = pathname_input.stringValue
        print_running_app()
    }
    
    @IBAction func do_eonil(_ sender: NSButton) {
        print("pathname is " + pathname)
        monitor = FileSystemEventMonitor(
            pathsToWatch: [pathname],
            latency: 1,
            watchRoot: true,
            queue: DispatchQueue.main) { (events: [FileSystemEvent])->() in
                print(events)
                print("MODIFICATION")
                print(events.count)
        }
        //eonil_stuff(path: pathname)
    }


}

