//
//  MainViewController.swift
//  MasterPlayer
//
//  Created by Glny Gl on 23.10.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import ParallaxHeader

class MainViewController: BaseViewController {
    
    var user: UserModel?
    var feedArray: [Feed]?
    var now = Date()
    var isLoadingMore = true
    var pageIndex = 0
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var parallaxImageView: UIImageView!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        setupParallaxHeader()
        
        SVProgressHUD.show()
        JSONServise.getJSON(self.pageIndex, success: { (responseData) in
            self.user = responseData
            self.feedArray = self.user?.feed?.sorted { (lhs: Feed, rhs: Feed) -> Bool in
                return (lhs.CreatedAt?.toDate())! > (rhs.CreatedAt?.toDate())!
            }
            self.userTableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            print(error)
        }
        roundedImageView()
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            self.feedArray = self.feedArray?.sorted { (lhs: Feed, rhs: Feed) -> Bool in
                return (lhs.CreatedAt?.toDate())! > (rhs.CreatedAt?.toDate())!
            }
            self.userTableView.reloadData()
        case 1:
            self.feedArray = self.feedArray?.sorted { (lhs: Feed, rhs: Feed) -> Bool in
                return lhs.FollowerCount?.toInt() ?? 0 > rhs.FollowerCount?.toInt() ?? 0
            }
            self.userTableView.reloadData()
        default:
            print("Default")
        }
    }
    
    func roundedImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor(red:0.23, green:0.25, blue:0.58, alpha:1.0).cgColor
        profileImageView.layer.borderWidth = 4
    }
    
    func loadMoreJSONByDate(){
        if !self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        SVProgressHUD.show()
        
        JSONServise.getJSON(self.pageIndex, success: { (responseData) in
            self.user = responseData
            if self.user?.feed?.count == 0 {
                self.isLoadingMore = false
                SVProgressHUD.dismiss()
                return
            }
            for item in (self.user?.feed)!{
                self.feedArray?.append(item)
            }
            self.feedArray = (self.feedArray?.sorted { (lhs: Feed, rhs: Feed) -> Bool in
                return (lhs.CreatedAt?.toDate())! > (rhs.CreatedAt?.toDate())!
                })!
            self.userTableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
        }
    }
    
    func loadMoreJSONByPopularity(){
        if !self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        SVProgressHUD.show()
        
        JSONServise.getJSON(self.pageIndex, success: { (responseData) in
            self.user = responseData
            if self.user?.feed?.count == 0 {
                self.isLoadingMore = false
                SVProgressHUD.dismiss()
                return
            }
            for item in (self.user?.feed)!{
                self.feedArray?.append(item)
            }
            self.feedArray = self.feedArray?.sorted { (lhs: Feed, rhs: Feed) -> Bool in
                return lhs.FollowerCount?.toInt() ?? 0 > rhs.FollowerCount?.toInt() ?? 0
            }
            SVProgressHUD.dismiss()
            self.userTableView.reloadData()
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListUsersTableViewCell", for: indexPath) as! ListUsersTableViewCell
        
        if let userResult = self.feedArray?[indexPath.row] {
            
            guard let profile = self.user?.user?.profilePhoto,
                let description = self.user?.user?.bio,
              //  let cover = self.user?.user?.coverPhoto,
                let name = userResult.Name,
                let date = userResult.CreatedAt,
                let follower = userResult.FollowerCount ,
                let photo = userResult.photo else { return UITableViewCell()}
            
            let passTime = Int(now.timeIntervalSince(date.toDate()))
            
           // self.parallaxImageView.af_setImage(withURL: URL(string: cover)!)
            self.profileImageView.af_setImage(withURL: URL(string: profile)!)
            self.userDescriptionLabel.text = description
            cell.userNameLabel.text = name
            cell.userTimeLabel.text = passTime.calculateTime()
            cell.userFollowerLabel.text = follower + " " + "Followers"
            cell.userImageView.af_setImage(withURL: URL(string: photo)!)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightSize = (UIScreen.main.bounds.height) / 8
        return heightSize
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.feedArray?.count)! - 1  && self.isLoadingMore == true {
            self.pageIndex += 10
            let index = segmentedControl.selectedSegmentIndex
            switch index {
            case 0:
                loadMoreJSONByDate()
            case 1:
                loadMoreJSONByPopularity()
            default:
                print("Default")
            }
        }
    }
    
    private func setupParallaxHeader() {
        
        self.parallaxImageView.contentMode = .scaleAspectFill
        self.userTableView.parallaxHeader.view = self.parallaxImageView
        self.userTableView.parallaxHeader.height = 160
        self.userTableView.parallaxHeader.minimumHeight = 0
        self.userTableView.parallaxHeader.mode = .centerFill
        self.userTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            //  print(parallaxHeader.progress)
        }
    }
    
}

extension String {
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)!
    }
}

extension Int {
    
    func calculateTime() -> String {
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if self < minute {
            return "\(time) seconds ago"
        }else if self < hour {
            return "\(self/minute) minutes ago"
        }else if self < day {
            return "\(self/hour) hours ago"
        }else if self < week {
            return "\(self/day) days ago"
        }else if self < month {
            return "\(self/week) weeks ago"
        }else if self < year {
            return "\(self/month) months ago"
        }else{
            return "\(self/year) years ago"
        }
    }
}
