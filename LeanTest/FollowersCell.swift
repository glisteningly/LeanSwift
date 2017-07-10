//
//  FollowersCell.swift
//  LeanTest
//
//  Created by AreX on 2017/7/9.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowersCell: UITableViewCell {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user: AVUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        // Initialization code
    }
    
    //单击后关注或者取消关注
    @IBAction func followBtn_clicked(_ sender: UIButton) {
        let title = followBtn.title(for: .normal)
        if title == "关注" {
            guard user != nil else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followBtn.setTitle("√已关注", for: .normal)
                    self.followBtn.setTitleColor(UIColor.lightGray, for: .normal)
                } else {
                    print(error?.localizedDescription ?? "关注失败")
                }
            })
        } else {
            guard user != nil else { return }
            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followBtn.setTitle("关注", for: .normal)
                    self.followBtn.setTitleColor(.blue, for: .normal)
                } else {
                    print(error?.localizedDescription ?? "取消关注失败")
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
