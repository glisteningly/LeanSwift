//
//  HeaderView.swift
//  LeanTest
//
//  Created by AreX on 2017/7/3.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func followBtn_clicked(_ sender: UIButton) {
        let title = button.title(for: .normal)
        let user = guestArray.last
        if title == "关注" {
            guard let user = user else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.button.setTitle("√已关注", for: .normal)
                    self.button.backgroundColor = UIColor.green
//                    self.button.setTitleColor(UIColor.green, for: .normal)
                } else {
                    print(error?.localizedDescription ?? "关注失败")
                }
            })
        } else {
            guard let user = user else { return }
            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.button.setTitle("关注", for: .normal)
                    self.button.backgroundColor = UIColor.lightGray
//                    self.button.setTitleColor(.blue, for: .normal)
                } else {
                    print(error?.localizedDescription ?? "取消关注失败")
                }
            })
        }
    }
    
}
