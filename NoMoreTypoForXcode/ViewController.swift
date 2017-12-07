//
//  ViewController.swift
//  NoMoreTypoForXcode
//
//  Created by Satsuki Hashiba on 2017/12/06.
//  Copyright © 2017年 Satsuki Hashiba. All rights reserved.
//

import Cocoa

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
    
    @IBAction func pushedEnableExtensionButton(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Extensions.prefPane"))
    }

    @IBAction func pushedGithubButton(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/shiba1014/NoMoreTypo") {
            NSWorkspace.shared.open(url)
        }
    }
}

