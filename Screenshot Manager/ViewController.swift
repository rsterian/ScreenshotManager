//
//  ViewController.swift
//  Screenshot Manager
//
//  Created by Riley Sterian on 5/8/17.
//  Copyright © 2017 rileyq. All rights reserved.
//

//http://stackoverflow.com/questions/24696044/nsfilemanager-fileexistsatpathisdirectory-and-swift
//http://stackoverflow.com/questions/12153504/accessing-the-desktop-in-a-sandboxed-app



import Cocoa
import Foundation

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

    @IBOutlet var select_button: NSButton!
    @IBOutlet weak var go_button: NSButton!
    @IBOutlet var textbar: NSTextField!
    @IBOutlet var pathname_input: NSTextField!
    
    @IBAction func press_sb(_ sender: NSButton) {
        if(pathname_input.stringValue != ""){
            let path:String = pathname_input.stringValue
            
            textbar.stringValue = "You entered " + path
            
        } else {
            textbar.stringValue = "blank"
        }
        
        let pathname:String = get_dir()
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
    }

    


}

