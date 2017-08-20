//
//  EditVC.swift
//  LeanTest
//
//  Created by AreX on 2017/8/17.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

        //在视图中创建PickerView
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker

        //单击imageview
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        //设置头像照片为圆角
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
    }

    func loadImg(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
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

    //获取器方法
    //设置获取器的组件数量
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //设置获取器种选项的数量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    //设置获取器选项的title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    //从获取器种获得用户选择的item
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
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
