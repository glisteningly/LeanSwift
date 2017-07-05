//
//  ResetPasswordVC.swift
//  LeanTest
//
//  Created by AreX on 2017/6/22.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func resetBtn_clicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "邮件地址不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        tryResetPassword()
    }
    
    func tryResetPassword() {
        AVUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) {
            (success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "请注意", message: "重置密码链接已经发送到你的电子邮箱", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                print(error?.localizedDescription ?? "密码重置失败")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
