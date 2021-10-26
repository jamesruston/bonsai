//
//  ViewController.swift
//  Bonsai
//
//  Created by jamesruston on 10/25/2018.
//  Copyright (c) 2018 jamesruston. All rights reserved.
//

import UIKit

enum MyBonsaiError: Swift.Error {
    case networkFailure
    case generic(String)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        demoDefaultLogging()
        demoDictionaryLogging()
        demoErrorLogging()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func demoDefaultLogging() {
        Logger.log(.verbose, "verbose")
        "TESTING".log(.verbose)
    }

    private func demoDictionaryLogging() {
        ["name": "Henry", "age": 6].log()
        [1: "The first item", 2: "The second item"].log()
        ["names": ["Mr. Orange", "Mr. Blonde", "Nice guy Eddie", "Mr. Pink", "Mr. Blue"]].log()
    }
    
    private func demoErrorLogging() {
        MyBonsaiError.networkFailure.log(.warning)
        MyBonsaiError.generic("Asset fetching error").log(.warning)
    }
}
