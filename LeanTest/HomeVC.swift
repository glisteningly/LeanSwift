//
//  HomeVC.swift
//  LeanTest
//
//  Created by AreX on 2017/7/3.
//  Copyright © 2017年 AreX. All rights reserved.
//

import UIKit
import AVOSCloud

//private let reuseIdentifier = "Cell"

class HomeVC: UICollectionViewController {
    //刷新控件
    var refresher: UIRefreshControl!
    //每页载入帖子数量
    var page: Int = 12
    var puuidArray = [String]()
    var picArray = [AVFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = AVUser.current()?.username?.uppercased()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        //设置refresher控件到集合视图中
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()
    }
    
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()?.username)
        query.limit = page
        query.findObjectsInBackground({ (objects: [Any]?, error: Error?) in
            if error == nil {
                self.puuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                //将查询到的数据添加到数组中
                for object in objects! {
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription ?? "查询失败")
            }
        })
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count * 20
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //从集合视图的可复用队列中获取单元格对象
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        
//        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
        picArray[0].getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription ?? "图片读取失败")
            }
        }
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        //获取用户信息
        header.fullnameLbl.text = (AVUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        //获取用户头像
        let avaQuery = AVUser.current()?.object(forKey: "ava") as? AVFile
        avaQuery?.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription ?? "无法获取头像")
            } else {
                header.avaImg.image = UIImage(data: data!)
            }
        }
        
        //获取帖子数
        let currentUser: AVUser = AVUser.current()!
        let postsQuery = AVQuery(className: "Posts")
        postsQuery.whereKey("username", equalTo: currentUser.username!)
        postsQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.posts.text = String(count)
            }
        }
        //获取用户关注数量
        let followersQuery = AVQuery(className: "_Follower")
        followersQuery.whereKey("user", equalTo: currentUser)
        followersQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.followers.text = String(count)
            }
        }
        //获取用户被关注数量
        let followeesQuery = AVQuery(className: "_Followee")
        followeesQuery.whereKey("user", equalTo: currentUser)
        followeesQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                header.followings.text = String(count)
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
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
            
        }
    }
    
    func followersTap(_ recognizer: UITapGestureRecognizer) {
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followers.user = AVUser.current()!.username!
        followers.show = "关注者"
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap(_ recognizer: UITapGestureRecognizer) {
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followings.user = AVUser.current()!.username!
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
