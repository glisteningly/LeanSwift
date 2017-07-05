//
//  SignInVC.swift
//  LeanTest
//
//  Created by AreX on 2017/6/22.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInVC: UIViewController {
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        label.font = UIFont(name: "Pacifico", size: 40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInBtn_clicked(_ sender: UIButton) {
        print("SignIn clicked!")
        
        self.view.endEditing(true)
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "用户名或密码未填写", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        trySignIn()
    }
    
    func trySignIn() {
        AVUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) {
            (user: AVUser?, error: Error?) in
            if error == nil {
                print("登陆成功")
                
                //记住用户
                UserDefaults.standard.set(user?.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                //调用AppDelegate类的login方法
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            } else {
                print("#######")
                print(error?.localizedDescription ?? "登录失败")
                print("#######")
            }
        }
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

