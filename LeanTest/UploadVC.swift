//
//  UploadVC.swift
//  LeanTest
//
//  Created by AreX on 2017/8/21.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    func initView() {
        //提交按钮初始禁用
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = UIColor.lightGray

        //单击imageView
        let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg))
        picTap.numberOfTapsRequired = 1
        picImg.addGestureRecognizer(picTap)

        removeBtn.isHidden = true

        picImg.image = UIImage(named: "pbg.png")
        titleText.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    //将选择的照片放入picImg 并且销毁照片获取器
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)

        //允许publishBtn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor.blue

        //显示移除按钮
        removeBtn.isHidden = false

        //实现二次单击放大图片
        unZoomedRect = self.picImg.frame

        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.addGestureRecognizer(zoomTap)
    }

    var unZoomedRect: CGRect? = nil

    func zoomImg() {
        //放大后的picImg位置
        let zoomedRect = CGRect(x: 0, y: self.view.center.y - self.view.center.x, width: self.view.frame.width, height: self.view.frame.width)

        if picImg.frame == unZoomedRect {
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = zoomedRect
                self.view.backgroundColor = .black
                self.titleText.alpha = 0
                self.publishBtn.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = self.unZoomedRect!
                self.view.backgroundColor = .white
                self.titleText.alpha = 1
                self.publishBtn.alpha = 1
            })
        }

    }

    @IBAction func publishBtn_clicked(_ sender: Any) {
        self.view.endEditing(true)

        let object = AVObject(className: "Posts")
        object["username"] = AVUser.current()?.username
        object["ava"] = AVUser.current()?.object(forKey: "ava") as! AVFile
//        object["puuid"] = "\(String(describing: AVUser.current()?.username!)) \(NSUUID().uuidString)"
        object["puuid"] = (AVUser.current()?.username)! + " " + NSUUID().uuidString

        //titleText是否为空
        if titleText.text.isEmpty {
            object["title"] = ""
        } else {
            object["title"] = titleText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        //生成照片数据
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = AVFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        object.saveInBackground { (success, error) in
            if error == nil {
                //发送uploaded通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                //将tabbar控制器种索引值为0的自控制器显示出来
                self.tabBarController?.selectedIndex = 0
                self.initView()

            }
        }
    }

    @IBAction func removeBtn_clicked(_ sender: Any) {
        self.initView()
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
