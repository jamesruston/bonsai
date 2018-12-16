//
//  ViewController.swift
//  Bonsai
//
//  Created by jamesruston on 10/25/2018.
//  Copyright (c) 2018 jamesruston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(.verbose, "verbose")
        "TESTING".log(.verbose)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

