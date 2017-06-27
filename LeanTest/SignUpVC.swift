//
//  SignUpVC.swift
//  LeanTest
//
//  Created by AreX on 2017/6/22.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var rePasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    根据需要设置滚动视图的高度
    var scrollViewHeight: CGFloat = 0
    
//    获取虚拟键盘的尺寸
    var keyboard: CGRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let hideTip = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTip.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTip)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpBtn_clicked(_ sender: UIButton) {
        print("SignUp clicked!")
        
    }
    
    @IBAction func cancelBtn_clicked(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
//当键盘出现或消失时调用
    func showKeyboard(notification: Notification){
//定义keyboard大小
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        
        UIView.animate(withDuration: 0.4){
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
        }
    }
    
    func hideKeyboard(notification: Notification){
        UIView.animate(withDuration: 0.4){
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    func hideKeyboardTap(rec: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}
