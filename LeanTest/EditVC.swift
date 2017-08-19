//
//  EditVC.swift
//  LeanTest
//
//  Created by AreX on 2017/8/17.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    var genderPicker: UIPickerView!
    var genders = ["男", "女"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        //设置bioTxt的样式
        bioTxt.layer.borderWidth = 0.5
        bioTxt.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        bioTxt.layer.cornerRadius = 5
        bioTxt.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func save_clicked(_ sender: Any) {
    }
    
    @IBAction func cancel_clicked(_ sender: Any) {
        //隐藏虚拟键盘
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
