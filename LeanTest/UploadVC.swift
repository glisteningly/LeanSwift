//
//  UploadVC.swift
//  LeanTest
//
//  Created by AreX on 2017/8/21.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var publishBtn: UIButton!

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
