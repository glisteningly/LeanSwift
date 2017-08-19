//
//  PictureCell.swift
//  LeanTest
//
//  Created by AreX on 2017/7/3.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    @IBOutlet weak var picImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let sideLength = UIScreen.main.bounds.width / 3
        //将单元格种imageview的尺寸同样设置为屏幕的1/3
        picImg.frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
    }
}
