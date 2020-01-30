//
//  UsersSearchController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/12/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools

class UsersSearchController: LBTAListController<UserSearchCell, User> {
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        view.backgroundColor = .white
        
        Service.shared.searchForUsers { (res) in
            switch res {
            case .failure(let err):
                print("Failed to find users: ", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = items[indexPath.item]
        let controller = ProfileController(userId: user.id)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


