//
//  UserSearchCell.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/12/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Alamofire

extension UsersSearchController {
    func didFollow(user: User) {
        guard let index = self.items.firstIndex(where: {$0.id == user.id}) else { return }
        
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to unfollow:", err)
                    return
                }
                
                self.items[index].isFollowing = !isFollowing
                self.collectionView.reloadItems(at: [[0, index]])
        }
        
    }
}

class UserSearchCell: LBTAListCell<User> {
    let nameLabel = UILabel(text: "Full Name", font: .boldSystemFont(ofSize: 16), textColor: .black)
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    @objc fileprivate func handleFollow() {
        (parentController as? UsersSearchController)?.didFollow(user: item)
    }
    
    override var item: User! {
        didSet {
            nameLabel.text = item.fullName
            
            if item.isFollowing == true {
                followButton.backgroundColor = .black
                followButton.setTitleColor(.white, for: .normal)
                followButton.setTitle("Unfollow", for: .normal)
            } else {
                followButton.backgroundColor = .white
                followButton.setTitleColor(.black, for: .normal)
                followButton.setTitle("Follow", for: .normal)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        followButton.layer.cornerRadius = 17
        followButton.layer.borderWidth = 1
        
        hstack(nameLabel,
               UIView(),
               followButton.withWidth(100).withHeight(34),
               alignment: .center)
            .padLeft(24).padRight(24)
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
}


