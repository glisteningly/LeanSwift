//
//  GuestVC.swift
//  LeanTest
//
//  Created by AreX on 2017/7/12.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

var guestArray = [AVUser]()
class GuestVC: UICollectionViewController {
    //刷新控件
    var refresher: UIRefreshControl!
    //每页载入帖子数量
    var page: Int = 12
    
    var puuidArray = [String]()
    var picArray = [AVFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //允许垂直的拉拽刷新操作
        self.collectionView?.alwaysBounceVertical = true
        
        //设置导航栏顶部信息
        self.navigationItem.title = guestArray.last?.username
        
        //定义导航栏的返回按钮
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //实现向右滑动返回
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.addGestureRecognizer(backSwipe)
        
        //安装refresher控件
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView?.addSubview(refresher)
        
        //设置集合视图的背景色为白色
        self.collectionView?.backgroundColor = .white
        
        loadPosts()
    }
    
    func back(_: UIBarButtonItem) {
        //退回到之前的控制器
        self.navigationController?.popViewController(animated: true)
        
        //从guestArray中移除随后一个AVUser
        if !guestArray.isEmpty {
            guestArray.removeLast()
        }
    }
    
    func refresh() {
        self.collectionView?.reloadData()
        self.refresher.endRefreshing()
    }
    
    func loadPosts() {
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: guestArray.last?.username)
        query.limit = page
        query.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            //查询成功
            if error == nil {
                //清空两个数组
                self.puuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    //将查询到的数据添加到数组中
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            }
                else {
                    print(error?.localizedDescription)
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        // Configure the cell
        //从云端下载帖子照片
        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription ?? "图片读取失败")
            }
        }
        
        return cell
    }
    
    //配置header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //定义header
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        
        //第一步 载入访客的基本信息
        let infoQuery = AVQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestArray.last?.username)
        infoQuery.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            if error == nil {
                //判断是否有用户数据
                guard let objects = objects, objects.count > 0 else {
                    return
                }
                
                //找到用户相关信息
                for object in objects {
                    header.fullnameLbl.text = ((object as AnyObject).object(forKey: "fullname") as? String)?.uppercased()
                    header.bioLbl.text = (object as AnyObject).object(forKey: "bio") as? String
                    header.bioLbl.sizeToFit()
                    header.webTxt.text = (object as AnyObject).object(forKey: "web") as? String
                    header.webTxt.sizeToFit()
                    
                    let avaFile = (object as AnyObject).object(forKey: "ava") as? AVFile
                    avaFile?.getDataInBackground({ (data: Data?, error: Error?) in
                        header.avaImg.image = UIImage(data: data!)
                    })
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        
        //第二步 设置当前用户和访客之间的关注关系
        let followeeQuery = AVUser.current()?.followeeQuery()
        followeeQuery?.whereKey("user", equalTo: AVUser.current()!)
        followeeQuery?.whereKey("followee", equalTo: guestArray.last!)
        followeeQuery?.countObjectsInBackground({ (count: Int, error: Error?) in
            guard error == nil else { print(error?.localizedDescription); return }
            
            if count == 0 {
                header.button.setTitle("关注", for: .normal)
                header.button.backgroundColor = UIColor.lightGray
            } else {
                header.button.setTitle("√已关注", for: .normal)
                header.button.backgroundColor = UIColor.green
            }
        })
        
        //第三步 计算统计数据
        //获取访客帖子数
        let postsQuery = AVQuery(className: "Posts")
        postsQuery.whereKey("username", equalTo: guestArray.last?.username)
        postsQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        //获取访客关注数量
        let followersQuery = AVUser.followerQuery((guestArray.last?.objectId)!)
        followersQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        //获取访客被关注数量
        let followeesQuery = AVUser.followeeQuery((guestArray.last?.objectId)!)
        followeesQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.followings.text = "\(count)"
            }
        }
        
        //实现点击事件
        //单击帖子数
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTap(_:)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        //单击关注者数
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTap(_:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        //单击关注数
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTap(_:)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        
        return header
    }
    
    func postsTap(_ recognizer: UITapGestureRecognizer) {
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: .top, animated: true)
            
        }
    }
    
    func followersTap(_ recognizer: UITapGestureRecognizer) {
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followers.user = guestArray.last!.username!
        followers.show = "关注者"
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap(_ recognizer: UITapGestureRecognizer) {
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followings.user = guestArray.last!.username!
        followings.show = "关注"
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
