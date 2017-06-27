//
//  ViewController.swift
//  LeanTest
//
//  Created by AreX on 2017/6/20.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let post = AVObject(className: "TestObject")
        post.setObject("Hello Swift!", forKey: "words")
        post.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

